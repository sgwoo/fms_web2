<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
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
	if(all_upchk.equals("")) all_upchk = "N";
	
	String vid[] 	= request.getParameterValues("ch_cd");
	int vid_size = vid.length;
	
	boolean flag = true;
	boolean flag1 = true;
	
	//cont
	ContBaseBean base = new ContBaseBean();
	
	if(vid_size>0){
		for(int i=0;i < vid_size;i++){
			
			m_id = vid[i].substring(0,6);
			l_cd = vid[i].substring(6,19);
			
			base = a_db.getCont(m_id, l_cd);
			
			String o_p_addr = base.getP_addr()+" "+base.getTax_agnt();
			
			base.setP_zip		(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
			base.setP_addr		(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
			base.setTax_agnt	(request.getParameter("tax_agnt")==null?"":request.getParameter("tax_agnt"));
			
			flag = a_db.updateContBaseNew(base);
			
			String n_p_addr = base.getP_addr()+" "+base.getTax_agnt();
			
			//우편물주소 변경이력 관리
			if(!o_p_addr.equals(n_p_addr)){
				LcRentCngHBean lrc_bean = new LcRentCngHBean();
				lrc_bean.setRent_mng_id	(m_id);
				lrc_bean.setRent_l_cd		(l_cd);
				lrc_bean.setCng_item		("p_addr");
				lrc_bean.setOld_value		(o_p_addr);
				lrc_bean.setNew_value		(n_p_addr);
				lrc_bean.setCng_cau			("우편물주소 변경");
				lrc_bean.setCng_id			(user_id);
				lrc_bean.setRent_st			("1");
				flag1 = a_db.updateLcRentCngH(lrc_bean);
			}
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
