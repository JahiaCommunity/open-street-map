package org.jahiacommunity.modules.location.filters;

import org.apache.commons.lang.StringUtils;
import org.jahia.services.render.RenderContext;
import org.jahia.services.render.Resource;
import org.jahia.services.render.filter.AbstractFilter;
import org.jahia.services.render.filter.RenderChain;

/**
 * Inject maps key (from Map provider) into request to be used client side by jsp.
 */
public class MapAttributesFilter extends AbstractFilter{
    private static final String OSM_MAP_KEY_ATTR = "osmMapKey";
    private String mapProviderApiKey;

    @Override
    public String prepare(RenderContext renderContext, Resource resource, RenderChain chain) throws Exception {
        if(StringUtils.isNotEmpty(mapProviderApiKey) && renderContext.getRequest().getAttribute(OSM_MAP_KEY_ATTR) == null) {
            renderContext.getRequest().setAttribute(OSM_MAP_KEY_ATTR, mapProviderApiKey);
        }
        return null;
    }

    public void setMapProviderApiKey(String mapProviderApiKey) {
        this.mapProviderApiKey = mapProviderApiKey;
    }
}
