<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.cl.*"%>
<jsp:useBean id="clsi_db" scope="page" class="acar.cl.ClSiteDatabase"/>
<jsp:useBean id="clsi" scope="page" class="acar.beans.ClSiteBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	clsi.setClient_id(request.getParameter("client_id"));
	clsi.setSite_st(request.getParameter("site_st"));	//지점1, 현장 2	
	clsi.setSite_nm(request.getParameter("site_nm"));	//지점명	
	clsi.setSite_jang(request.getParameter("site_jang")); //지점장
	clsi.setEnp_no(request.getParameter("enp_no1")+request.getParameter("enp_no2")+request.getParameter("enp_no3"));
	clsi.setOpen_year(request.getParameter("open_year"));
	clsi.setTel(request.getParameter("tel"));
	clsi.setFax(request.getParameter("fax"));
	clsi.setZip(request.getParameter("zip"));
	clsi.setAddr(request.getParameter("addr"));
	clsi.setAgnt_nm(request.getParameter("agnt_nm"));
	clsi.setAgnt_tel(request.getParameter("agnt_tel"));
	clsi.setReg_id(user_id);
	
	boolean flag = clsi_db.insertClSite(clsi);
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body leftmargin="15">

<script language='javascript'>
<%	if(flag){ %>
	alert('정상적으로 등록되었습니다');
	var fm = parent.opener.form1;
<%			//사용본거지
			Vector c_sites = clsi_db.getClientSites(request.getParameter("client_id"));
			int c_site_size = c_sites.size();
		    if(c_site_size > 0){
				for(int i = 0 ; i < c_site_size ; i++){
					ClSiteBean site = (ClSiteBean)c_sites.elementAt(i);
					if(c_site_size > 1){%>
						parent.opener.add_site(0, '', '선택');
						fm.site_id.options[0].selected = true;
						parent.opener.add_site(<%=(i+1)%>, '<%=site.getSite_id()%>', '<%=site.getSite_nm()%>');
<%					}else{%>			
						parent.opener.add_site(0, '', '선택');
						fm.site_id.options.selected = true;
						parent.opener.add_site(<%=(i+1)%>, '<%=site.getSite_id()%>', '<%=site.getSite_nm()%>');
<%					} %>
<%				}
  			}	%>	
	fm.site_id.options[<%= c_sites.size() %>].selected = true;		
	parent.close();	
<%	}else{%>
	alert('데이터베이스 에러입니다.등록되지 않았습니다.');
<%	}%>
</script>
</body>
</html>