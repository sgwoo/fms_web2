<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.cl.*"%>
<jsp:useBean id="clre_db" scope="page" class="acar.cl.ClRegDatabase"/>
<jsp:useBean id="clsi_db" scope="page" class="acar.cl.ClSiteDatabase"/>
<jsp:useBean id="client" scope="page" class="acar.beans.ClRegBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String page_gubun = request.getParameter("h_page_gubun");
	String client_id = "";
	int count =0;
	
	if(page_gubun.equals("NEW")){ //신규등록한 고객
		client.setClient_st(request.getParameter("client_st"));
		client.setClient_nm(request.getParameter("client_nm"));
		client.setFirm_nm(request.getParameter("firm_nm"));
		client.setSsn1(request.getParameter("ssn1"));
		client.setSsn2(request.getParameter("ssn2"));
		//개인사업자는 생년월일만
		if(client.getClient_st().equals("3") || client.getClient_st().equals("4") || client.getClient_st().equals("5")) {
			client.setSsn2	("");
		}
		client.setEnp_no1(request.getParameter("enp_no1"));
		client.setEnp_no2(request.getParameter("enp_no2"));
		client.setEnp_no3(request.getParameter("enp_no3"));
		client.setH_tel(request.getParameter("h_tel"));
		client.setO_tel(request.getParameter("o_tel"));
		client.setM_tel(request.getParameter("m_tel"));
		client.setHomepage(request.getParameter("homepage").equals("http://")?"":request.getParameter("homepage"));
		client.setFax(request.getParameter("fax"));
		client.setBus_cdt(request.getParameter("bus_cdt"));
		client.setBus_itm(request.getParameter("bus_itm"));
		String zip[] = request.getParameterValues("zip");
		String addr[] = request.getParameterValues("addr");
		client.setC_zip(zip[0]);
		client.setC_addr(addr[0]);
		client.setHo_zip(zip[1]);
		client.setHo_addr(addr[1]);
		client.setO_zip(zip[2]);
		client.setO_addr(addr[2]);
		client.setOpen_year(request.getParameter("open_year").equals("")?"":AddUtil.ChangeString(request.getParameter("open_year")));
		client.setFirm_price(request.getParameter("firm_price").equals("")?0:AddUtil.parseDigit(request.getParameter("firm_price")));
		client.setFirm_price_y(request.getParameter("firm_price_y").equals("")?0:AddUtil.parseDigit(request.getParameter("firm_price_y")));
		client.setFirm_day(request.getParameter("firm_day").equals("")?"":AddUtil.ChangeString(request.getParameter("firm_day")));
		client.setFirm_day_y(request.getParameter("firm_day_y").equals("")?"":AddUtil.ChangeString(request.getParameter("firm_day_y")));
		String ssn1 = request.getParameter("c_ssn1")==null?"":request.getParameter("c_ssn1");
		String ssn2 = request.getParameter("c_ssn2")==null?"":request.getParameter("c_ssn2");
		client.setC_ssn(ssn1);
		client.setReg_id(user_id);
		
		if(client.getClient_st().equals("1") || client.getClient_st().equals("2")) {
			count = clre_db.checkSSN(client.getSsn1()+client.getSsn2());//주민(법인)등록번호 중복체크하고 없으면 입력
		}
		
		if(count == 0){
			client_id = clre_db.insertClReg(client);
		}
	}
%>
<html>
<head>
<title></title>
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body leftmargin="15">

	<script language='javascript'>
<%	if(count == 0){
		if(!client_id.equals("")){ //정상
			if(page_gubun.equals("NEW")){%>
				alert('정상적으로 등록되었습니다');
<%			}%>
				var fm = parent.opener.form1;
				fm.client_id.value 	= <%="'" + client_id + "'"%>;	
				fm.firm_nm.value 	= <%="'" + client.getFirm_nm() + "'"%>;
				fm.site_chk0.checked = true;
				fm.site_chk1.checked = true;
				fm.site_chk2.checked = true;									
<%			//사용본거지
			Vector c_sites = clsi_db.getClientSites(client.getClient_id());
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
						parent.close();			
<%		}else{ //에러%>
				alert('등록되지 않았습니다');
<%		}
	}else{%>
				alert('이미 등록된 주민(법인)등록번호입니다.\n\n확인하십시오.');
<%	}%>
</script>
</body>
</html>