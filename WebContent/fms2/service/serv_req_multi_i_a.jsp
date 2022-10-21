<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.cus_reg.*"%>
<%@ page import="acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*, acar.cus_samt.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<jsp:useBean id="cs_db" scope="page" class="acar.cus_samt.CusSamt_Database"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String vid1[] = request.getParameterValues("car_mng_id");
	String vid2[] = request.getParameterValues("serv_id");
				
	int vid_size = 0;
	vid_size = vid1.length;
	
	String auth_rw 		= request.getParameter("auth_rw")		==null?"":request.getParameter("auth_rw");	
	String user_id = request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");//�α���-ID
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");   //7:���ǵ����Ʈ 10:Ÿ�̾���Ÿ�� , 9:�ִ�ī���� 8:�β���ī��Ÿ 
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"3":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
				
	String from_page = "/fms2/service/serv_doc_frame.jsp";
		
	String ch_c_id="";  
	String ch_s_id="";
			
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	
	int result = 0;
	
	String s_kd_nm = "";
	String off_id = ""; //�����ڵ��� setting ->�˻�� ���� ����ڰ�  ���� (007410)  - �ϵ�����Ź�۹��� 008411
	
	if( s_kd.equals("7")) {
		s_kd_nm = "���ǵ����Ʈ";
		off_id = "009694"; //ma_partner�� cd_partner code  off_id = 009694 , 995697
	} else if (s_kd.equals("8") ) {
		s_kd_nm = "�β���ī��Ÿ";
		off_id = "000092";
	} else if (s_kd.equals("9") ) {
		s_kd_nm = "�ִ�ī����";
		off_id = ""; //��ǥ��
	} else if (s_kd.equals("10") ) {
		s_kd_nm = "Ÿ�̾���Ÿ��";	
		off_id = "008634";
	} else if (s_kd.equals("11") ) {
		s_kd_nm = "�����ڵ���";
		off_id = "005392";
	} else if (s_kd.equals("14") ) {
		s_kd_nm = "���������ڵ���";
		off_id = "011605";
	} else if (s_kd.equals("15") ) {
		s_kd_nm = "�ٷ�������";	
		off_id = "011771";
	}
	
	//String ven_code = "";
		
%>

<% //������ jung_dt �� ���� - �������� ���� ����  - ���� ���� �ְŷ�ó�� ( excel ��ϰ�, Ÿ�̾���Ÿ��, �β���ī��Ÿ �� )
	String jung_dt 	= request.getParameter("jung_dt")==null?"":request.getParameter("jung_dt");  //�������� ( service.set_dt )
	
	CarSchDatabase csd = CarSchDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	String req_code  = Long.toString(System.currentTimeMillis());
	
	for(int i=0;i < vid_size;i++){
		
		ch_c_id = vid1[i];
		ch_s_id = vid2[i];
				
		result = cr_db.updateServiceSet(ch_c_id, ch_s_id, user_id , jung_dt, req_code);	//���� setting   
		      
	}	
   
	String s_yy = "";
	String s_mm = "";
	jung_dt = AddUtil.replace(jung_dt,"-","");	 
	s_yy =  jung_dt.substring(0,4);
	s_mm =  jung_dt.substring(4,6);
	
	int labor_amt = request.getParameter("labor_amt")==null?0: AddUtil.parseInt(request.getParameter("labor_amt")); //���� 
	int j_amt = request.getParameter("j_amt")==null?0: AddUtil.parseInt(request.getParameter("j_amt"));	  //��ǰ 
	int dc_amt = request.getParameter("dc_amt")==null?0: AddUtil.parseInt(request.getParameter("dc_amt"));  //dc  - ���ް� (����)
	int add_amt = request.getParameter("add_amt")==null?0: AddUtil.parseInt(request.getParameter("add_amt"));  //�ΰ���
	int add_dc_amt = request.getParameter("add_dc_amt")==null?0: AddUtil.parseInt(request.getParameter("add_dc_amt"));  //dc  - �ΰ��� (����)
		
	//mj_jungsan table insert �߰� 
	flag6 = cs_db.updateMJ_Jungsan(off_id, s_yy, s_mm, "1", labor_amt, j_amt, 0,  0, dc_amt, add_amt , add_dc_amt,  user_id);
		 
	System.out.println("����� ���� - �ϰ�û�� ó�� ->" + s_kd_nm + " : " + jung_dt + ":" + req_code );
	
	String sub  = "";
	String cont = "";
	String target_id = "";
	String doc_no = "";
	
	String user_id2 = "000026";
//	String user_id2 = "000063";  //test
	
	//�����忬�� -> ����������, ������, �������忬�� -> ȸ������ڷ�
	CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);  		
		
	if(!cs_bean2.getWork_id().equals("") ) {	
		user_id2 = "XXXXXX"; //����	
	}	
	
	if ( !jung_dt.equals("")  ) {
			
		//1. ����ó���� ���-------------------------------------------------------------------------------------------		
		DocSettleBean doc = new DocSettleBean();
	  		
		sub 	= s_kd_nm + "�����  ������Ǽ� ���� ��û ";
		cont 	= "[ ��������: "+jung_dt+"] "+ s_kd_nm + " ����� ������Ǽ� ���縦 ��û�մϴ�.";			//��ü�� �߰�??	
		target_id = "";
			
		doc.setDoc_st("54");// �ڵ��� ����� ���� ���� ��û
		doc.setDoc_id(req_code);
		doc.setSub(sub);
		doc.setCont(cont);
		doc.setEtc(s_kd);
			
		doc.setUser_nm1("�����");
		doc.setUser_nm2("����������");
		doc.setUser_nm3("�ѹ�����");
		doc.setUser_id1(user_id);
		doc.setUser_id2(user_id2);//��������
		doc.setUser_id3("000004");//�ѹ�����
			
		doc.setDoc_bit("1");//���Ŵܰ�
		doc.setDoc_step("1");//���
		
				
		//=====[doc_settle] insert=====
		flag3 = d_db.insertDocSettle(doc);
	//	doc_no = doc.getDoc_no();
	     
		//������ ���� skip
		if ( doc.getUser_id2().equals("XXXXXX") ) {		
			  DocSettleBean doc1 = new DocSettleBean();
		      doc1 = d_db.getDocSettleCommi("54", req_code);
			  doc_no = doc1.getDoc_no();
					
			  flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "2",  "2");		
		}
		
		
		//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
			
		String url 	= "/fms2/service/serv_doc_frame.jsp";
		sub 	= s_kd_nm + " �����  ������Ǽ� ���� ��û ";
		cont 	= "[ ��������: "+jung_dt+"] "+ s_kd_nm + " ����� ������Ǽ� ���縦 ��û�մϴ�.";			//��ü�� �߰�??	
					
		target_id = "";
			
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
			
		target_id = doc.getUser_id2();
		
		if (target_id.equals("XXXXXX")) {
				target_id = doc.getUser_id3();
		}	
				
			
		UsersBean target_bean 	= umd.getUsersBean(target_id);
			
		String xml_data = "";
		xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
	  					"    <BACKIMG>4</BACKIMG>"+
	  					"    <MSGTYPE>104</MSGTYPE>"+
		  				"    <SUB>"+sub+"</SUB>"+
	  					"    <CONT>"+cont+"</CONT>"+
	  					"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";
			
		//�޴»��
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
			
		//�������
		xml_data += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
			
	  					"    <MSGICON>10</MSGICON>"+
	  					"    <MSGSAVE>1</MSGSAVE>"+
	  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
		  				"    <FLDTYPE>1</FLDTYPE>"+
	  					"  </ALERTMSG>"+
	  					"</COOLMSG>";
			
		CdAlertBean msg = new CdAlertBean();
		msg.setFlddata(xml_data);
		msg.setFldtype("1");
			
		flag4 = cm_db.insertCoolMsg(msg);
		//out.println("��޽��� ����<br>");
		System.out.println("��޽���(�ڵ��� ����� ���������û) "+s_kd_nm+ " : " + jung_dt+"-----------------------"+target_bean.getUser_nm());
	}
%>
<script language='javascript'>
<%	if( result  < 1 ){	%>	alert('���� �����Դϴ�.\n\nȮ���Ͻʽÿ�');					<%		}	%>			
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name="mode" 				value="<%=mode%>">
  <input type='hidden' name="from_page" 		value="<%=from_page%>"> 
</form>

<script language='javascript'>
	var fm = document.form1;	
	alert('ó���Ǿ����ϴ�');	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
	
	parent.window.close();	
</script>

</body>
</html>
