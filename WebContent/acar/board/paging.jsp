<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<%@ page import="java.util.*, acar.util.*"%>

<%

String actionPath = request.getParameter("actionPath");

String sNowPage = request.getParameter("nowPage");
String sTotalCount = request.getParameter("totalCount");

String sCountPerPage = request.getParameter("countPerPage");
String sblockCount = request.getParameter("blockCount");

String searchColumn = request.getParameter("searchColumn");
String searchWord = request.getParameter("searchWord");

int nowPage = (sNowPage == null || sNowPage.trim().equals("")) ? 1 : AddUtil.parseInt(sNowPage);
int totalCount = (sTotalCount == null || sTotalCount.trim().equals("")) ? 0 : AddUtil.parseInt(sTotalCount);
int countPerPage = (sCountPerPage == null || sCountPerPage.trim().equals("")) ? 1 : AddUtil.parseInt(sCountPerPage);
int countPerBlock = (sblockCount == null || sblockCount.trim().equals("")) ? 1 : AddUtil.parseInt(sblockCount);

int totalPage = (int)( (totalCount-1)/countPerPage ) + 1;
if(totalPage == 0) totalPage = 1 ;

int totalBlock   = (int)((totalPage-1)/(countPerBlock));
int nowBlock     = (int)((nowPage - 1) / countPerBlock);

int firstPage = 0;
int prevPage = 0;
int nextPage = 0;
int lastPage = 0;

if (nowBlock > 0) {
	firstPage = 1;
}
if( nowPage > 1 ) {
	prevPage = nowPage - 1;
}

int startPage = nowBlock * countPerBlock + 1;
int endPage = countPerBlock * (nowBlock + 1);

if ( endPage > totalPage ) endPage = totalPage;


if( nowPage < totalPage ) {
	nextPage = nowPage + 1;
}
if( nowBlock < totalBlock ) {
	lastPage = totalPage;
}
%>
<script type="text/javascript">
function gotoPage(pageNum) {
	var objForm = document.frmPaging;
	objForm.nowPage.value = pageNum;
	objForm.submit();
}
</script>
<form name="frmPaging" method="get" action="<%=actionPath%>">

	<input type="hidden" name="nowPage" value=""/>
	<input type="hidden" name="searchColumn" value="<%=searchColumn %>">
	<input type="hidden" name="searchWord" value="<%=searchWord %>">

	<table border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td align="left">
				<%if (firstPage > 0) { %>
				<a href="#" onclick="javascript:gotoPage('<%=firstPage%>');">처음</a>
				<%} %>
				<%if (prevPage > 0) { %>
				<a href="#" onclick="javascript:gotoPage('<%=prevPage%>');">이전</a>
				<%} %>
				<%for (int indexI = startPage; indexI <= endPage; indexI++) { %>
					<%if (indexI == nowPage) { %>
					<%=indexI %>
					<%} else { %>
					<a href="#" onclick="javascript:gotoPage('<%=indexI%>');">[<%=indexI %>]</a> 
					<%} %>
				<%} %>
				<%if (nextPage > 0) { %>
				<a href="#" onclick="javascript:gotoPage('<%=nextPage%>');">다음</a>
				<%} %>
				<%if (lastPage > 0) { %>
				<a href="#" onclick="javascript:gotoPage('<%=lastPage%>');">마지막</a>
				<%} %>
			</td>
		</tr>
	</table>
</form>