<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<template:addResources type="css" resources="location.css"/>
<c:set var="props" value="${currentNode.propertiesAsString}"/>

<div class="location">
    <c:if test="${not empty props['jcr:title']}">
        <h3>${fn:escapeXml(props['jcr:title'])}</h3>
    </c:if>

    <c:if test="${not empty props['street']}">
        <p class="location-item">${fn:escapeXml(props['street'])}</p>
    </c:if>
    <c:if test="${not empty props['zipCode'] || not empty props['town']}">
        <p class="location-item">
            <c:if test="${not empty props['zipCode']}">
                ${fn:escapeXml(props['zipCode'])}&nbsp;
            </c:if>
            ${not empty props['town'] ? fn:escapeXml(props['town']) : ''}
        </p>
    </c:if>
    <p class="location-item">
        <jcr:nodePropertyRenderer name="country" node="${currentNode}" renderer="country" var="country"/>${fn:escapeXml(country.displayName)}
    </p>
</div>