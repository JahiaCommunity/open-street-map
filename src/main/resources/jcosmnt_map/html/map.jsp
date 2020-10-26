<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="ui" uri="http://www.jahia.org/tags/uiComponentsLib" %>

<c:set var="bindedComponent" value="${ui:getBindedComponent(currentNode, renderContext, 'j:bindedComponent')}"/>
<c:if test="${not empty bindedComponent && jcr:isNodeType(bindedComponent, 'jcosmmix:geotagged,jcosmmix:locationAware,jcosmnt:location')}">
    <c:set var="props" value="${currentNode.propertiesAsString}"/>

    <c:if test="${!renderContext.editMode}">
        <template:addResources type="css" rel="stylesheet" resources="leaflet.css" />
        <template:addResources type="javascript" resources="leaflet.js" />

        <c:set var="targetProps" value="${bindedComponent.propertiesAsString}"/>
        <c:if test="${not empty osmMapKey}">
            <c:set var="mapKey" value="${osmMapKey}"/>
        </c:if>

        <c:if test="${not empty targetProps['latitude'] && not empty targetProps['longitude']}">
            <c:set var="location" value="${targetProps['latitude']}, ${targetProps['longitude']}" />
        </c:if>
        <c:set var="zoom" value="${targetProps['zoom']}" />
        <c:if test="${empty zoom}">
            <c:set var="zoom" value="18"/>
        </c:if>
        <c:set var="makeMapStatic" value="${currentNode.properties['makeMapStatic'].boolean}" />

	    <template:addResources>
	        <script type="text/javascript">
	            $(document).ready(function() {
	                var options = '';
	                <c:if test="${makeMapStatic}" >
                        //https://leafletjs.com/reference-1.7.1.html#map-zoomcontrol
                        options = { zoomControl: false, trackResize:true, boxZoom:false, doubleClickZoom:false,dragging: false };
                    </c:if>
                    options.zoom = '${zoom}';
                    options.center = [${location}];
					var mymap = L.map('mapid-${currentNode.identifier}', options).setView([${location}], ${zoom});
					L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
						attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
					}).addTo(mymap);
                    L.marker([${location}]).addTo(mymap);
				});
	        </script>
	    </template:addResources>
	</c:if>

    <div>
        <c:if test="${not empty props['jcr:title']}">
            <h3>${fn:escapeXml(props['jcr:title'])}</h3>
        </c:if>

        <div id="mapid-${currentNode.identifier}" style="width:${props['width']}px; height:${props['height']}px">
        	<c:if test="${renderContext.editMode}">
        		<p><fmt:message key="jcosmnt_map.noPreviewInEditMode"/></p>
        	</c:if>
        </div>
    </div>

</c:if>
