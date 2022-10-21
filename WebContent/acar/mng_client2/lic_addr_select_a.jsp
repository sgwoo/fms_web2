<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.cont.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%//@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String client_nm = request.getParameter("client_nm")==null?"":request.getParameter("client_nm");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	
	String all_upchk = request.getParameter("all_upchk")==null?"N":request.getParameter("all_upchk");
	String all_upchk2 = request.getParameter("all_upchk2")==null?"N":request.getParameter("all_upchk2");
	
	if(all_upchk.equals("")) all_upchk = "N";
	if(all_upchk2.equals("")) all_upchk2 = "N";
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	boolean flag = true;
	boolean flag1 = true;
	boolean flag2 = true;
	
	//cont
	ContBaseBean base = new ContBaseBean();
	
	if(vid_size>0){
		for(int i=0;i < vid_size;i++){
			
			m_id = vid[i].substring(0,6);
			l_cd = vid[i].substring(6,19);
			
			base = a_db.getCont(m_id, l_cd);
			
			String o_lic = base.getLic_no();
			String o_m_lic = base.getMgr_lic_no()+""+base.getMgr_lic_emp()+""+base.getMgr_lic_rel();
			
			base.setLic_no		(request.getParameter("lic_no")		==null?"":request.getParameter("lic_no"));
			base.setMgr_lic_no	(request.getParameter("mgr_lic_no")==null?"":request.getParameter("mgr_lic_no"));	
			base.setMgr_lic_emp	(request.getParameter("mgr_lic_emp")==null?"":request.getParameter("mgr_lic_emp"));	
			base.setMgr_lic_rel	(request.getParameter("mgr_lic_rel")==null?"":request.getParameter("mgr_lic_rel"));	
			
			flag = a_db.updateContBaseNew(base);
			
			String n_lic = base.getLic_no();
			String n_m_lic = base.getMgr_lic_no()+""+base.getMgr_lic_emp()+""+base.getMgr_lic_rel();
			
			//변경이력 관리
			if(!o_lic.equals(n_lic)){
				LcRentCngHBean lrc_bean = new LcRentCngHBean();
				lrc_bean.setRent_mng_id	(m_id);
				lrc_bean.setRent_l_cd		(l_cd);
				lrc_bean.setCng_item		("lic_no");
				lrc_bean.setOld_value		(o_lic);
				lrc_bean.setNew_value		(n_lic);
				lrc_bean.setCng_cau			("계약자 운전면허번호 일괄변경");
				lrc_bean.setCng_id			(user_id);
				lrc_bean.setRent_st			("1");
				flag1 = a_db.updateLcRentCngH(lrc_bean);
			}
			//변경이력 관리
			if(!o_m_lic.equals(n_m_lic)){
				LcRentCngHBean lrc_bean = new LcRentCngHBean();
				lrc_bean.setRent_mng_id	(m_id);
				lrc_bean.setRent_l_cd		(l_cd);
				lrc_bean.setCng_item		("mgr_lic_no");
				lrc_bean.setOld_value		(o_m_lic);
				lrc_bean.setNew_value		(n_m_lic);
				lrc_bean.setCng_cau			("차량이용자 운전면허번호 일괄변경");
				lrc_bean.setCng_id			(user_id);
				lrc_bean.setRent_st			("1");
				flag1 = a_db.updateLcRentCngH(lrc_bean);
			}	
		}
	}
	
	if(all_upchk2.equals("Y")){//해당건만 수정
		ClientBean client = al_db.getNewClient(client_id);
		String o_client_lic_no = client.getLic_no();
		client.setLic_no		(request.getParameter("lic_no")==null?"":request.getParameter("lic_no"));
		flag2 = al_db.updateNewClient2(client);
		String n_client_lic_no = client.getLic_no();
		
				//변경이력 관리
				if(!o_client_lic_no.equals(n_client_lic_no)){
					LcRentCngHBean lrc_bean = new LcRentCngHBean();
					lrc_bean.setRent_mng_id		(m_id);
					lrc_bean.setRent_l_cd		(l_cd);
					lrc_bean.setCng_item		("client.lic_no");
					lrc_bean.setOld_value		(o_client_lic_no);
					lrc_bean.setNew_value		(n_client_lic_no);
					lrc_bean.setCng_cau			("고객 운전면허번호 일괄변경");
					lrc_bean.setCng_id			(user_id);
					lrc_bean.setRent_st			("1");			
					flag1 = a_db.updateLcRentCngH(lrc_bean);
				}
	}
	

%>
<script language='javascript'>
<%	if(flag){%>
		alert('수정되었습니다');
		parent.window.close();
		parent.opener.location.reload();		
<%	}else{%>
		alert('수정되지 않았습니다');
<%	}%>
</script>
</body>
</html>
