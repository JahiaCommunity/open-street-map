<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<template:addResources type="css" resources="location.css"/>
<c:set var="props" value="${currentNode.propertiesAsString}"/>

<div class="location">
    <h3>${fn:escapeXml(props['jcr:title'])}</h3>

    <p class="location-item"><span class="location-label"><fmt:message key="jcosmmix_locationAware.street"/>:</span>
        <span class="location-value">${fn:escapeXml(props['street'])}</span>
    </p>

    <p class="location-item"><span class="location-label"><fmt:message key="jcosmmix_locationAware.zipCode"/>:</span>
        <span class="location-value">${fn:escapeXml(props['zipCode'])}</span>
    </p>
    <p class="location-item"><span class="location-label"><fmt:message key="jcosmmix_locationAware.town"/>:</span>
        <span class="location-value">${fn:escapeXml(props['town'])}</span>
    </p>
    <p class="location-item"><span class="location-label"><fmt:message key="jcosmmix_locationAware.country"/>:</span>
        <span class="location-value"><jcr:nodePropertyRenderer name="country" node="${currentNode}" renderer="country" var="country"/>${fn:escapeXml(country.displayName)}</span>
    </p>
    <p class="location-item"><span class="location-label"><fmt:message key="jcosmmix_geotagged.latitude"/>:</span>
        <span class="location-value">${fn:escapeXml(props['latitude'])}</span>
    </p>
    <p class="location-item"><span class="location-label"><fmt:message key="jcosmmix_geotagged.longitude"/>:</span>
        <span class="location-value">${fn:escapeXml(props['longitude'])}</span>
    </p>
</div>