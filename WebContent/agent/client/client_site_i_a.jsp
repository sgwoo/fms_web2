<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*, acar.bill_mng.*"%>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
</head>
<body leftmargin="15">
<%
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String h_con = request.getParameter("h_con")==null?"":request.getParameter("h_con");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String seq = request.getParameter("site_id")==null?"":request.getParameter("site_id");
	
	boolean flag = false;
	int flag2 = 0;
	
	ClientSiteBean c_site = al_db.getClientSite(client_id, seq);
	
	c_site.setClient_id(client_id);
	c_site.setSeq(seq);
	c_site.setR_site(request.getParameter("site_nm")==null?"":request.getParameter("site_nm"));
	//추가
	c_site.setSite_st(request.getParameter("site_st")==null?"":request.getParameter("site_st"));
	c_site.setSite_jang(request.getParameter("site_jang")==null?"":request.getParameter("site_jang"));
	c_site.setEnp_no(request.getParameter("enp_no")==null?"":request.getParameter("enp_no"));
	c_site.setZip(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
	c_site.setAddr(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
	c_site.setBus_cdt(request.getParameter("bus_cdt")==null?"":request.getParameter("bus_cdt"));
	c_site.setBus_itm(request.getParameter("bus_itm")==null?"":request.getParameter("bus_itm"));
	c_site.setOpen_year(request.getParameter("open_year")==null?"":request.getParameter("open_year"));
	c_site.setTel(request.getParameter("tel")==null?"":request.getParameter("tel"));
	c_site.setFax(request.getParameter("fax")==null?"":request.getParameter("fax"));
	c_site.setAgnt_nm(request.getParameter("agnt_nm")==null?"":request.getParameter("agnt_nm"));
	c_site.setAgnt_tel(request.getParameter("agnt_tel")==null?"":request.getParameter("agnt_tel"));
	c_site.setVen_code(request.getParameter("ven_code")==null?"":request.getParameter("ven_code"));
	c_site.setUpd_id(user_id);	
	c_site.setAgnt_m_tel(request.getParameter("agnt_m_tel")==null?"":request.getParameter("agnt_m_tel"));
	c_site.setAgnt_fax	(request.getParameter("agnt_fax")==null?"":request.getParameter("agnt_fax"));
	c_site.setAgnt_email(request.getParameter("agnt_email")==null?"":request.getParameter("agnt_email"));
	c_site.setAgnt_dept	(request.getParameter("agnt_dept")==null?"":request.getParameter("agnt_dept"));
	c_site.setAgnt_title(request.getParameter("agnt_title")==null?"":request.getParameter("agnt_title"));
	c_site.setAgnt_nm2(request.getParameter("agnt_nm2")==null?"":request.getParameter("agnt_nm2"));
	c_site.setAgnt_tel2(request.getParameter("agnt_tel2")==null?"":request.getParameter("agnt_tel2"));
	c_site.setAgnt_m_tel2(request.getParameter("agnt_m_tel2")==null?"":request.getParameter("agnt_m_tel2"));
	c_site.setAgnt_fax2	(request.getParameter("agnt_fax2")==null?"":request.getParameter("agnt_fax2"));
	c_site.setAgnt_email2(request.getParameter("agnt_email2")==null?"":request.getParameter("agnt_email2"));
	c_site.setAgnt_dept2(request.getParameter("agnt_dept2")==null?"":request.getParameter("agnt_dept2"));
	c_site.setAgnt_title2(request.getParameter("agnt_title2")==null?"":request.getParameter("agnt_title2"));	
	
	if(seq.equals("")){
		
		//네오엠 거래처 처리-------------------------------
		
		String ven_code ="";
		
		if(c_site.getEnp_no().length() == 13){//개인
			ven_code = neoe_db.getVenCode(c_site.getEnp_no(), "");
		}else{
			ven_code = neoe_db.getVenCode2("", c_site.getEnp_no());
		}
		
		if(ven_code.equals("") && c_site.getEnp_no().length()>=10){
				
			TradeBean t_bean = new TradeBean();
						
			t_bean.setCust_name	(AddUtil.substring(c_site.getR_site(),15));
			if(c_site.getEnp_no().length() == 13){//개인
				t_bean.setId_no	(c_site.getEnp_no());
				t_bean.setS_idno("8888888888");
			}else{
				t_bean.setS_idno(c_site.getEnp_no());
			}
			t_bean.setDname		(AddUtil.substring(c_site.getSite_jang(),15));
			t_bean.setMail_no	(c_site.getZip());
			t_bean.setS_address	(AddUtil.substring(c_site.getAddr(),30));
			t_bean.setUptae		(AddUtil.substring(c_site.getBus_cdt(),15));
			t_bean.setJong		(AddUtil.substring(c_site.getBus_itm(),15));
						
			if(!neoe_db.insertTrade(t_bean)) flag2 += 1;
			
			if(c_site.getEnp_no().length() == 13){//개인
				ven_code = neoe_db.getVenCode(c_site.getEnp_no(), "");
			}else{
				ven_code = neoe_db.getVenCode2("", c_site.getEnp_no());
			}		
			c_site.setVen_code	(ven_code);
			
		}else{
			c_site.setVen_code	(ven_code);
		}
		
		flag = al_db.insertClientSite(c_site);
	}else{
		if(c_site.getVen_code().equals("") && c_site.getEnp_no().length()>=10){
			String ven_code ="";
			
			if(c_site.getEnp_no().length() == 13){//개인
				ven_code = neoe_db.getVenCode(c_site.getEnp_no(), "");
			}else{
				ven_code = neoe_db.getVenCode2("", c_site.getEnp_no());
			}
			if(ven_code.equals("")){
						
				TradeBean t_bean = new TradeBean();
				
				t_bean.setCust_name	(AddUtil.substring(c_site.getR_site(),15));
				if(c_site.getEnp_no().length() == 13){//개인
					t_bean.setId_no	(c_site.getEnp_no());
					t_bean.setS_idno("8888888888");
				}else{
					t_bean.setS_idno(c_site.getEnp_no());
				}
				t_bean.setDname		(AddUtil.substring(c_site.getSite_jang(),15));
				t_bean.setMail_no	(c_site.getZip());
				t_bean.setS_address	(AddUtil.substring(c_site.getAddr(),30));
				t_bean.setUptae		(AddUtil.substring(c_site.getBus_cdt(),15));
				t_bean.setJong		(AddUtil.substring(c_site.getBus_itm(),15));
				
				if(!neoe_db.insertTrade(t_bean)) flag2 += 1;
				
				if(c_site.getEnp_no().length() == 13){//개인
					ven_code = neoe_db.getVenCode(c_site.getEnp_no(), "");
				}else{
					ven_code = neoe_db.getVenCode2("", c_site.getEnp_no());
				}					
				c_site.setVen_code	(ven_code);
								
			}else{
				c_site.setVen_code	(ven_code);
			}
		}
		
		flag = al_db.updateClientSite(c_site);
	}
%>
<form name='form1' action='./client_site_s_p.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='firm_nm' value='<%=firm_nm%>'>
<input type='hidden' name='h_con' value='<%=h_con%>'>
<input type='hidden' name='h_wd' value='<%=h_wd%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'> 
</form>
	<script language='javascript'>
<%	if(flag){%>
				alert('정상적으로 처리되었습니다');

				var fm = document.form1;
				fm.target = "CLIENT_SITE";
				fm.submit();
			
<%	}else{ //에러%>
				alert('처리되지 않았습니다');
<%	}%>
</script>
</body>
</html>
