<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cls.*,  acar.cont.*, acar.credit.*, acar.user_mng.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">

<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String reg_id = request.getParameter("reg_id")==null?ck_acar_id:request.getParameter("reg_id");
	
	//ä�ǰ���, ����ä���� ó���ǰ�/���û���
	ClsEtcBean cls = ac_db.getClsEtcCase(rent_mng_id, rent_l_cd);	
//	String cls_st = cls.getCls_st_r();
	String cls_st = request.getParameter("cls_st")==null?"":request.getParameter("cls_st");
	
	int flag = 0;
		
	cls.setRent_mng_id(rent_mng_id);
	cls.setRent_l_cd	(rent_l_cd);
	
	cls.setCls_dt(request.getParameter("cls_dt"));
	cls.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//���̿�Ⱓ ��
	cls.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//���̿�Ⱓ ��
	cls.setCls_st(cls_st);	
	cls.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//��������
	cls.setReg_id(reg_id); //�����id
	cls.setUpd_id	(user_id);
	cls.setD_saction_id(request.getParameter("d_saction_id")==null?"":	request.getParameter("d_saction_id")); //Ȯ���ݾ� ������
	cls.setD_reason(request.getParameter("d_reason")==null?"":	request.getParameter("d_reason"));             //Ȯ���ݾ� ����
	cls.setDly_saction_id(request.getParameter("dly_saction_id")==null?"":	request.getParameter("dly_saction_id")); //��ü�ᰨ�� ������
	cls.setDly_reason(request.getParameter("dly_reason")==null?"":	request.getParameter("dly_reason"));       //��ü�ᰨ�� ����
	cls.setDft_saction_id(request.getParameter("dft_saction_id")==null?"":	request.getParameter("dft_saction_id")); //�ߵ���������ݰ��� ������
	cls.setDft_reason(request.getParameter("dft_reason")==null?"":	request.getParameter("dft_reason"));       //�ߵ���������ݰ��� ����	
	cls.setRemark(request.getParameter("remark")==null?"":	request.getParameter("remark"));       //���û��� ��Ÿ�ǰ�
	cls.setCms_chk(request.getParameter("cms_chk")==null?"":	request.getParameter("cms_chk"));       //cms �����Ƿ�
	cls.setDft_cost_id(request.getParameter("dft_cost_id")==null?"":	request.getParameter("dft_cost_id")); //����ȿ�������
		//��ȯ������
	cls.setRe_bank(request.getParameter("re_bank")==null?"":request.getParameter("re_bank"));            //����
	cls.setRe_acc_no(request.getParameter("re_acc_no")==null?"":request.getParameter("re_acc_no"));      //ȯ�Ұ��¹�ȣ
	cls.setRe_acc_nm(request.getParameter("re_acc_nm")==null?"":request.getParameter("re_acc_nm"));      //ȯ�� �����ָ�
	cls.setTot_dist(request.getParameter("tot_dist")==null?0:AddUtil.parseDigit(request.getParameter("tot_dist")));   //��������Ÿ�
	
	cls.setMatch(request.getParameter("match")==null?"":request.getParameter("match"));      //�����Ī
	cls.setExt_saction_id(request.getParameter("ext_saction_id")==null?"":	request.getParameter("ext_saction_id")); //�������ĺ�ó�� ������
	cls.setExt_reason(request.getParameter("ext_reason")==null?"":	request.getParameter("ext_reason"));       //�������ĺ�ó�� ����	
		
	boolean cr1_flag = ac_db.updateClsEtcCau(cls);
	
	String cms_after = request.getParameter("cms_after")==null?"":request.getParameter("cms_after");		
		
	//�����Ƿڳ��� �߰� �׸� - 20180907 cls_etc field�� �ʹ� ���Ƽ� cls_etc_more�� �߰� 		
	if ( !ac_db.updateClsCmsAfter(rent_mng_id, rent_l_cd, cms_after ) )	flag += 1;			
	
	//�������Ȱ��� ���  - �������濡 ���� ����
	int cls_cnt = 0;
	
	cls_cnt = ac_db.getContClsCnt(rent_mng_id, rent_l_cd);	
	
	if ( cls_cnt > 0 ) {
		if ( cls_st.equals("1") || cls_st.equals("2") || cls_st.equals("14")|| cls_st.equals("8")   ) {
			
			//��������
			ClsBean clr = as_db.getClsCase(rent_mng_id, rent_l_cd);				
					
			//�ߵ�����,  �������� �����Ƿ� ���		
			clr.setCls_dt(request.getParameter("cls_dt"));
			clr.setCls_st(cls_st);	
			clr.setR_mon(request.getParameter("r_mon")==null?"":	request.getParameter("r_mon"));//���̿�Ⱓ ��
			clr.setR_day(request.getParameter("r_day")==null?"":	request.getParameter("r_day"));//���̿�Ⱓ ��
				
			clr.setCls_cau(request.getParameter("cls_cau")==null?"":request.getParameter("cls_cau"));//��������
			clr.setTot_dist(request.getParameter("tot_dist")==null?0:AddUtil.parseDigit(request.getParameter("tot_dist")));   //��������Ÿ�			
		
			clr.setCms_chk(request.getParameter("cms_chk")==null?"N":request.getParameter("cms_chk"));  //cms�����Ƿ�
			
			if(!as_db.updateCls(clr))	flag += 1;								
		}
		
		if (  cls_st.equals("7") || cls_st.equals("10") ) {
			if ( !as_db.updateClsSt(rent_mng_id, rent_l_cd, cls_st ) )	flag += 1;			
		}
	}	
				
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
%>
<script language='javascript'>
<%	if(!cr1_flag){  %>
		alert("ó������ �ʾҽ��ϴ�");
		location='about:blank';		
<%	}else{		%>
		alert("ó���Ǿ����ϴ�");
		parent.opener.location.href = "lc_cls_d_frame.jsp<%=valus%>";
		parent.window.close();
<%	}			%>
</script>