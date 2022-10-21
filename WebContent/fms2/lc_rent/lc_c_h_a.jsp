<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.cont.*, acar.car_office.*, acar.res_search.*, acar.ext.*, acar.secondhand.*, acar.client.*, acar.im_email.*, tax.*, acar.car_mst.*, acar.coolmsg.*, acar.user_mng.*, acar.car_register.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="ImEmailDb" scope="page" class="acar.im_email.ImEmailDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
//	if(1==1)return;
	
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String idx 			= request.getParameter("idx")==null?"":request.getParameter("idx");
	
	String car_gu 		= request.getParameter("car_gu")==null?"1":request.getParameter("car_gu");//����1,����0
	String car_st 		= request.getParameter("car_st")==null?"":request.getParameter("car_st");
	String now_stat 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int flag = 0;
	
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 		= CarRegDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//cont
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
%>


<%
	if(cng_item.equals("cont_check")){
		//�뿩��Ÿ����-----------------------------------------------------------------------------------------------
		
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
		if(fee_etc.getRent_mng_id().equals("")){
			fee_etc.setRent_mng_id	(rent_mng_id);
			fee_etc.setRent_l_cd	(rent_l_cd);
			fee_etc.setRent_st		(rent_st);
			//=====[fee_etc] insert=====
			flag2 = a_db.insertFeeEtc(fee_etc);
		}
		
		//=====[fee_etc] update=====
		flag1 = a_db.updateFeeEtcCheck(rent_mng_id, rent_l_cd, rent_st, user_id);
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('���� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("cont_cng_check")){
		//�뿩��Ÿ����-----------------------------------------------------------------------------------------------
		
		//fee_etc
		ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, rent_st);
		if(fee_etc.getRent_mng_id().equals("")){
			fee_etc.setRent_mng_id	(rent_mng_id);
			fee_etc.setRent_l_cd	(rent_l_cd);
			fee_etc.setRent_st		(rent_st);
			//=====[fee_etc] insert=====
			flag2 = a_db.insertFeeEtc(fee_etc);
		}
		
		//=====[fee_etc] update=====
		flag1 = a_db.updateFeeEtcCngCheck(rent_mng_id, rent_l_cd, rent_st, user_id);
		
		
		//20191108 ���°��� ��ຯ��Ȯ�ν�  ���ȳ����� �߼� �Ѵ�.
		if(now_stat.equals("�°���")){  // || now_stat.equals("������")
			
			//�ŷ�ó����
			ClientBean client = al_db.getClient(base.getClient_id());
			
   			//���վȳ��� �� ���Ϲ߼�
   			if(client.getCon_agnt_email().length() > 5 ){	
   		
				//	1. d-mail ���-------------------------------
	
				DmailBean d_bean = new DmailBean();
				d_bean.setSubject			(client.getFirm_nm()+"��, (��)�Ƹ���ī ���� ���� �ȳ����Դϴ�."); //���뿩 �̿� �ȳ���
				d_bean.setSql				("SSV:"+client.getCon_agnt_email().trim());
				d_bean.setReject_slist_idx	(0);
				d_bean.setBlock_group_idx	(0);
				d_bean.setMailfrom			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
				d_bean.setMailto			("\""+client.getFirm_nm()+"\"<"+client.getCon_agnt_email().trim()+">");
				d_bean.setReplyto			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
				d_bean.setErrosto			("\"�Ƹ���ī\"<tax@amazoncar.co.kr>");
				d_bean.setHtml				(1);
				d_bean.setEncoding			(0);
				d_bean.setCharset			("euc-kr");
				d_bean.setDuration_set		(1);
				d_bean.setClick_set			(0);
				d_bean.setSite_set			(0);
				d_bean.setAtc_set			(0);
				d_bean.setGubun				(rent_l_cd+"scd_fee");
				d_bean.setRname				("mail");
				d_bean.setMtype       		(0);
				d_bean.setU_idx       		(1);//admin����
				d_bean.setG_idx				(1);//admin����
				d_bean.setMsgflag     		(0);	
				d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/total/mail_service.jsp?m_id="+rent_mng_id+"&l_cd="+rent_l_cd+"&rent_st=1");
			
				if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+3")) flag += 1;
				
				String car_comp_id = "";
				//�����⺻����
				ContCarBean car = a_db.getContCarNew(rent_mng_id, rent_l_cd);
				//�ڵ����⺻����
				cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
				car_comp_id = cm_bean.getCar_comp_id();	
			
				//20140210 �����ڵ��� ������� �ȳ����� �߼�
				if(car_comp_id.equals("0001") && base.getCar_gu().equals("1")){
			
					d_bean.setSubject			(client.getFirm_nm()+"��, �����ڵ��� ����������� ���� �ȳ����Դϴ�. (��)�Ƹ���ī");
					d_bean.setGubun				(rent_l_cd+"bluemem");
					d_bean.setContent			("http://fms1.amazoncar.co.kr/mailing/etc/bluemem.html");
					if(!ImEmailDb.insertDEmail(d_bean, "4", "", "+3")) flag += 1;						
				}      			
		
   			}	
   			
   			
   			//20210714 ���°��������� �޽��� �߼� : �°�ó�� �Ϸ�޽���
   			
   			//�����������
   			if(!base.getCar_mng_id().equals("")){
   				cr_bean = crd.getCarRegBean(base.getCar_mng_id());
   			}
   			
   			String sub2 		= "�°�ó���Ϸ�";
   			String cont2 		= client.getFirm_nm() + " "+cr_bean.getCar_no()+" ���� ���°� �������̰� �� ó�� �Ϸ�Ǿ����ϴ�.";
   			
   			UsersBean sender_bean 	= umd.getUsersBean(ck_acar_id);
   			UsersBean target_bean 	= umd.getUsersBean(base.getBus_id());
   			
   			String xml_data2 = "";
			xml_data2 =  "<COOLMSG>"+
	  						"<ALERTMSG>"+
							"    <BACKIMG>4</BACKIMG>"+
	  						"    <MSGTYPE>104</MSGTYPE>"+
							"    <SUB>"+sub2+"</SUB>"+
	  						"    <CONT>"+cont2+"</CONT>"+
							"    <URL></URL>";
			xml_data2 += "   <TARGET>"+target_bean.getId()+"</TARGET>";
			
			xml_data2 += "   <SENDER>"+sender_bean.getId()+"</SENDER>"+
							"    <MSGICON>10</MSGICON>"+
	  						"    <MSGSAVE>1</MSGSAVE>"+
	 						"    <LEAVEDMSG>1</LEAVEDMSG>"+
  							"    <FLDTYPE>1</FLDTYPE>"+
	 						"  </ALERTMSG>"+
  							"</COOLMSG>";
		
			CdAlertBean msg2 = new CdAlertBean();
			msg2.setFlddata(xml_data2);
			msg2.setFldtype("1");
					
			boolean m_flag2 = cm_db.insertCoolMsg(msg2);
   			
   			
		}
		
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('����Ȯ�� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
</script>
<%	}%>

<%
	if(cng_item.equals("cancel_cls")){
		
		//����Ȱ
		flag1 = a_db.rebirthCont(rent_mng_id, rent_l_cd, base.getCar_mng_id());
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('����Ȱ ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
</script>
<%	}%>


<%
	String del_chk = "Y";
	
	//����Ʈ �������� ������� ����ϱ�
	if(cng_item.equals("lc_rm_delete")){
	
		String sh_res_seq = ec_db.getShResSeq(rent_mng_id, rent_l_cd);
		
		if(!sh_res_seq.equals("")){
			ShResBean shBn = shDb.getShRes(base.getCar_mng_id(), sh_res_seq);
			if(shBn.getUse_yn().equals("Y")){
				//���ó��
				String  d_flag1 =  shDb.call_sp_sh_res_dire_cancel(base.getCar_mng_id(), sh_res_seq);
				
				//call_sp_sh_res_dire_cancel���� ���ó���� �ȵǾ� �ִٸ� �������� ó��
				if(base.getUse_yn().equals("Y")){
					//flag1 = a_db.deleteCont(rent_mng_id, rent_l_cd);
					base.setUse_yn("N");
					//=====[cont] update=====
					flag1 = a_db.updateContBaseNew(base);
					//������ �츮��
					flag2 = a_db.rebirthUseCar(base.getCar_mng_id());
					//������� ���°� �ʱ�ȭ
					flag3 = a_db.updateCarStatCng(base.getCar_mng_id());	
					//����������
					flag3 = a_db.updateRmScdFeeCancel(rent_mng_id, rent_l_cd);
				}
			}else{
				//���ڰ�� ���۰��� �������� ���� (������� ����)
				//int alink_count2 = ln_db.getALinkCnt("rm_rent_link",   rent_l_cd);
				//int alink_count3 = ln_db.getALinkCnt("rm_rent_link_m", rent_l_cd);
				//if(alink_count2 > 0){
				//	del_chk = "N";
				//}
				//if(del_chk.equals("Y")){
					//flag1 = a_db.deleteCont(rent_mng_id, rent_l_cd);
					base.setUse_yn("N");
					//=====[cont] update=====
					flag1 = a_db.updateContBaseNew(base);
					//������ �츮��
					flag2 = a_db.rebirthUseCar(base.getCar_mng_id());
					//������� ���°� �ʱ�ȭ
					flag3 = a_db.updateCarStatCng(base.getCar_mng_id());
					//����������
					flag3 = a_db.updateRmScdFeeCancel(rent_mng_id, rent_l_cd);
				//}
			}
		}
		
		
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('����Ʈ �������� ������� ��� �����Դϴ�.\n\nȮ���Ͻʽÿ�');	<%		}	%>		
</script>
<%	}%>



<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
  <input type="hidden" name="br_id" 			value="<%=br_id%>">    
  <input type="hidden" name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type="hidden" name="rent_l_cd" 		value="<%=rent_l_cd%>">  
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 				value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 			value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
</form>
<script language='javascript'>

	var fm = document.form1;
	
	fm.action = 'lc_c_h.jsp';
	fm.target = 'c_body';
	<%if(cng_item.equals("lc_rm_delete")){%>
		
		<%if(del_chk.equals("N")){%>
			alert('���ڰ�� ���۰��� �������� ���մϴ�. ���� ����Ͻʽÿ�.');
		<%}%>
		
		fm.action = 'lc_rm_frame.jsp';
		fm.target = 'd_content';
	<%}%>
	fm.submit();
	
</script>
</body>
</html>