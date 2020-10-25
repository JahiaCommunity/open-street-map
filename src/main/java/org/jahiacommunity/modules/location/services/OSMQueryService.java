package org.jahiacommunity.modules.location.services;

import org.jahiacommunity.modules.location.models.Address;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Query;

import java.util.List;

public interface OSMQueryService {

    @GET("search?addressdetails=0&format=json&limit=1")
    Call<List<Address>> search(@Query("q") String query);

}


