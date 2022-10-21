<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.m_bbs.*"%>
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
	String gubun_st = request.getParameter("gubun_st")==null?"":request.getParameter("gubun_st");
	
	
	M_bbs_Database m_db = M_bbs_Database.getInstance();
	
	
	Vector conts = m_db.getM_bbs_List(member_id, gubun, s_yy, AddUtil.addZero(s_mm), s_dd, s_kd, t_wd, 0, 0 );
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
				<tr>
					<td width=6% class=title align=center>연번</td>
					<td width=50% class=title>제목</td>
					<td width=22% class=title>작성자</td>
					<td width=12% class=title>작성일자</td>
					<td width=10% class=title>조회수</td>
				</tr>				
				<% if(cont_size > 0){	%>
				<% for(int i = 0 ; i < cont_size ; i++){
					Hashtable cont = (Hashtable)conts.elementAt(i);%>
				<tr> 
					<td align='center'><a name="<%=i+1%>"><%=i+1%></a>
					</td>
					<td>
						<%if(!String.valueOf(cont.get("RE_LEVEL")).equals("0")){%>
						<%for(int j=0; j<AddUtil.parseInt(String.valueOf(cont.get("RE_LEVEL"))); j++){ out.println("&nbsp;&nbsp;"); }%>
						<img src="../../images/cust/rei.gif" width="25" height="9">
						<%}%>
        		  		&nbsp; 
						<a href="javascript:parent.getViewCont('<%=i+1%>','<%=cont.get("BBS_ID")%>');"><%=cont.get("TITLE")%></a>
					</td>
					<td align='center'><%=cont.get("FIRM_NM")%></td>
					<td align='center'><%=AddUtil.ChangeDate2(String.valueOf(cont.get("REG_DT")))%>	</td>
					<td align='center'><%=cont.get("HIT")%>	</td>
                </tr>
	                <%		}%>
    	            <%	}else{%>
                <tr> 
                    <td align='center' colspan="5">해당 데이타가 없습니다.</td>
                </tr>
        		    <%	}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
