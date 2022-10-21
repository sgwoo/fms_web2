<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.insur.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
		
	InsDatabase ai_db = InsDatabase.getInstance();
	
%>

<%

	String vid[]  = request.getParameterValues("ch_l_cd");
	String vid2[] = request.getParameterValues("m_id");
	String vid3[] = request.getParameterValues("l_cd");
	String vid4[] = request.getParameterValues("c_id");
	String vid5[] = request.getParameterValues("seq_no");
	
	String vid_num="";
	String m_id="";
	String l_cd="";
	String c_id="";
	String seq_no="";
	int flag = 0;
	
	int vid_size = vid.length;
	
	String reg_code = "FA"+Long.toString(System.currentTimeMillis());
	
	//�ߺ�üũ
	int chk_cnt = FineDocDb.getRegCodeChk(reg_code);
	
	if(chk_cnt == 0){
		for(int i=0;i < vid_size;i++){
			vid_num 	= vid[i];
			m_id 		= vid2[AddUtil.parseInt(vid_num)];
			l_cd 		= vid3[AddUtil.parseInt(vid_num)];
			c_id 		= vid4[AddUtil.parseInt(vid_num)];
			seq_no 	= vid5[AddUtil.parseInt(vid_num)];
			InsurExcelBean ins = new InsurExcelBean();
			ins.setReg_code	(reg_code);
			ins.setSeq			(i);
			ins.setReg_id		(ck_acar_id);
			ins.setGubun		("");
			ins.setValue01	(m_id);
			ins.setValue02	(l_cd);
			ins.setValue03	(c_id);
			ins.setValue04	(seq_no);
			if(!ai_db.insertInsExcel(ins))	flag += 1;
		}
		
		String  d_flag1 =  FineDocDb.call_sp_fine_doc_all_reg(reg_code);
		
	}
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>
<%	if(chk_cnt>0){%>	
			alert('�ߺ��� ����ڵ��Դϴ�. �ٽ� ó�����ּ���.');
<%	}else{%>	
<%		if(flag==0){%>
			alert("���������� ó���Ǿ����ϴ�.");
			parent.location.reload();
			//parent.window.close();
<%		}else{%>
			alert("�����߻�!");
<%		}%>
<%	}%>
</script>
</body>
</html>

