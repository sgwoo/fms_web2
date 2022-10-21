<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*"%>
<jsp:useBean id="clre_db" scope="page" class="acar.cl.ClRegDatabase"/>
<jsp:useBean id="clsi_db" scope="page" class="acar.cl.ClSiteDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String page_gubun = request.getParameter("page_gubun");
	int count =0;
	
	ClRegBean client = new ClRegBean();
	
	if(page_gubun.equals("EXT")||page_gubun.equals("RES")){ // 검색결과에서 선택한 고객을 계약기본화면으로 보내준다
		String client_id = request.getParameter("client_id");
		client = clre_db.getClReg(client_id);
	}
//System.out.println("page_gubun="+page_gubun);	
%>

<html>
<head>
<title></title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body leftmargin="15">
	<script language='javascript'>
		var fm = parent.opener.form1;

<%	if(page_gubun.equals("EXT") && client != null){  %>			//영업지원 -> 계약등록에서
		fm.client_id.value 	= <%="'" + client.getClient_id() + "'"%>;		
		fm.firm_nm.value 	= <%="'" + client.getFirm_nm() + "'"%>;
		fm.site_chk0.checked = true;
		fm.site_chk1.checked = true;
		fm.site_chk2.checked = true;								
<%		//사용본거지
		Vector c_sites = clsi_db.getClientSites(client.getClient_id());
		int c_site_size = c_sites.size();
		if(c_site_size > 0){
			for(int i = 0 ; i < c_site_size ; i++){
				ClSiteBean site = (ClSiteBean)c_sites.elementAt(i);
				if(c_site_size > 1){%>
					parent.opener.add_site(0, '', '선택');
					fm.site_id.options[0].selected = true;
					parent.opener.add_site(<%=(i+1)%>, '<%=site.getSite_id()%>', '<%=site.getSite_nm()%>');
<%				}else{//한건만 있으면%>			
					parent.opener.add_site(0, '', '선택');
					fm.site_id.options.selected = true;
					parent.opener.add_site(<%=(i+1)%>, '<%=site.getSite_id()%>', '<%=site.getSite_nm()%>');
<%				}%>
<%			}
  		}else{	%>
					parent.opener.drop_site();
<%		} %>	
								
<%	}else if(page_gubun.equals("RES") && client != null){%>	//예약시스템->예약등록에서
		fm.client_id.value 	= <%="'" + client.getClient_id() + "'"%>;		
		fm.firm_nm.value 	= <%="'" + client.getFirm_nm() + "'"%>;
		fm.client_nm.value	= <%="'" + client.getClient_nm() + "'"%>;
		
<%  } %>
parent.window.close();
</script>
</body>
</html>