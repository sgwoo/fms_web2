<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.mrent_bbs.*"%>
<%@page import="acar.util.PagingBean"%>
<%@page import="acar.util.PagingUtil"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String member_id = request.getParameter("member_id")==null?"":request.getParameter("member_id");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String r_site = request.getParameter("r_site")==null?"":request.getParameter("r_site");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String gubun = request.getParameter("gubun")==null?"1":request.getParameter("gubun");
	String s_yy = request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm = request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	String s_dd = request.getParameter("s_dd")==null?"":request.getParameter("s_dd");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	
	Mrent_BbsDatabase MB_db = Mrent_BbsDatabase.getInstance();
	
	PagingBean paging = new PagingBean();
	if(request.getParameter("nowPage") == null){
		paging.setNowPage(1);
	}else{
		paging.setNowPage(AddUtil.parseInt(request.getParameter("nowPage")));
	}
	
	int totalCount = 0;
	
	totalCount =  MB_db.getMrent_bbs_cnt(member_id, gubun, s_yy, AddUtil.addZero(s_mm), s_dd, s_kd, t_wd);
		
	paging.setTotalCount(totalCount);
	paging = PagingUtil.setPagingInfo(paging);	
	
	//Vector conts = MB_db.getM_bbs_List(member_id, gubun, s_yy, AddUtil.addZero(s_mm), s_dd, s_kd, t_wd, paging.getStartNum(), paging.getCountPerPage() );
	
	Vector conts = MB_db.ViewListAll();
	
	int cont_size = conts.size();
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<body leftmargin=0>
<table border="0" cellspacing="0" cellpadding="0" width='100%'>
	<tr> 
		<td class='line'> 
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<% if(cont_size > 0){	%>
				<% for(int i = 0 ; i < cont_size ; i++){
					Hashtable cont = (Hashtable)conts.elementAt(i);%>
				<tr> 
					<td align='center' width='6%'><a name="<%=i+1%>"><%=i+1%></a>
					</td>
					<td width='70%'>				
						<a href="javascript:parent.getViewCont('<%=i+1%>','<%=cont.get("BBS_ID")%>');"><%=cont.get("TITLE")%></a>
					</td>
					<td align='center' width='12%'><%=cont.get("USER_NM")%></td>
					<td align='center' width='12%'><%=AddUtil.ChangeDate2(String.valueOf(cont.get("REG_DT")))%>	</td>
                </tr>
	                <%		}%>
    	            <%	}else{%>
                <tr> 
                    <td align='center' colspan="4">???? ???????? ????????.</td>
                </tr>
        		    <%	}%>
            </table>
        </td>
    </tr>
    
    <tr>
			<td colspan="5" align="center">
				<jsp:include page="paging.jsp">
					<jsp:param name="actionPath" value="board_sc_in.jsp"/>
					<jsp:param name="totalCount" value="<%=String.valueOf(paging.getTotalCount()) %>"/>
					<jsp:param name="countPerPage" value="<%=String.valueOf(paging.getCountPerPage()) %>"/>
					<jsp:param name="blockCount" value="<%=String.valueOf(paging.getBlockCount()) %>"/>
					<jsp:param name="nowPage" value="<%=String.valueOf(paging.getNowPage()) %>"/>
				</jsp:include>
			</td>
	</tr>
</table>
</body>
</html>
