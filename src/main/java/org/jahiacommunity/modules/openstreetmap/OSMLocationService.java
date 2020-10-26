package org.jahiacommunity.modules.openstreetmap;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import org.jahiacommunity.modules.openstreetmap.models.Address;
import org.jahiacommunity.modules.openstreetmap.services.OSMQueryService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import retrofit2.Call;
import retrofit2.Retrofit;
import retrofit2.converter.jackson.JacksonConverterFactory;

import org.drools.core.spi.KnowledgeHelper;
import org.jahia.services.content.JCRNodeWrapper;
import org.jahia.services.content.rules.AddedNodeFact;
import javax.jcr.RepositoryException;
import java.io.IOException;
import java.util.List;
import java.util.concurrent.TimeUnit;


public class OSMLocationService {

    private static final transient Logger logger = LoggerFactory.getLogger(OSMLocationService.class);
    private OSMQueryService osmQueryService;

    private OSMQueryService initialize(){
        HttpLoggingInterceptor interceptor = new HttpLoggingInterceptor();
        if (logger.isDebugEnabled()) {
            interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);
        } else if (logger.isInfoEnabled()) {
            interceptor.setLevel(HttpLoggingInterceptor.Level.BASIC);
        } else {
            interceptor.setLevel(HttpLoggingInterceptor.Level.NONE);
        }

        //TODO: to remove (for tests):
        interceptor.setLevel(HttpLoggingInterceptor.Level.BODY);

        OkHttpClient client = new OkHttpClient.Builder().addInterceptor(interceptor)
                .connectTimeout(120, TimeUnit.SECONDS)
                .writeTimeout(180, TimeUnit.SECONDS)
                .readTimeout(200, TimeUnit.SECONDS)
                .build();

        ObjectMapper customMapper = new ObjectMapper();
        SimpleModule myModule = new SimpleModule();
        //myModule.addDeserializer(String.class, (JsonDeserializer) new Null2EmptyDeserializer());
        customMapper.setSerializationInclusion(JsonInclude.Include.ALWAYS);
        customMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
        customMapper.registerModule(myModule);

        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl("https://nominatim.openstreetmap.org")
                .client(client)
                .addConverterFactory(JacksonConverterFactory.create(customMapper))
                // .addConverterFactory(JacksonConverterFactory.create())
                .build();
        osmQueryService = retrofit.create(OSMQueryService.class);
        return osmQueryService;
    }

    public void geocodeLocation(AddedNodeFact node, KnowledgeHelper drools) throws RepositoryException {

        if (osmQueryService==null) {
            osmQueryService = initialize();
        }
        JCRNodeWrapper nodeWrapper = node.getNode();
        StringBuilder queryAddress = new StringBuilder();
        if (nodeWrapper.hasProperty("street")) {
            queryAddress.append(nodeWrapper.getProperty("street").getString());
        }
        if (nodeWrapper.hasProperty("zipCode")) {
            queryAddress.append(" ").append(nodeWrapper.getProperty("zipCode").getString());
        }
        if (nodeWrapper.hasProperty("town")) {
            queryAddress.append(" ").append(nodeWrapper.getProperty("town").getString());
        }
        if (nodeWrapper.hasProperty("country")) {
            queryAddress.append(" ").append(nodeWrapper.getProperty("country").getString());
        }
        if (!nodeWrapper.isNodeType("jcosmnt:location") && !nodeWrapper.isNodeType("jcosmmix:geotagged")) {
            nodeWrapper.addMixin("jcosmmix:geotagged");
        }
        if (queryAddress.length() > 0) {
            Call<List<Address>> searchCall = osmQueryService.search(queryAddress.toString());
            List<Address> addresses;
            Address address;
            try {
                logger.debug(">>>> OSM search? >> request =" + searchCall.request());
                addresses = searchCall.execute().body();
                logger.info("DEBUG >>>> searchCall.execute().body() size={}", (addresses == null ? null : addresses.size()));
                if (addresses != null && !addresses.isEmpty()) {
                    address = addresses.get(0);
                    nodeWrapper.setProperty("latitude", address.getLat());
                    nodeWrapper.setProperty("longitude", address.getLon());
                }
            } catch (IOException | IndexOutOfBoundsException e) {
                logger.warn(e.getMessage(), e);
            }
        }
    }
}