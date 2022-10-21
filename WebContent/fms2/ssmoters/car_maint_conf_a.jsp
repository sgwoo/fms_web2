<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.util.*"%>
<%@ page import="acar.master_car.*, acar.doc_settle.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<%
	String auth_rw 	= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String from_page = "/fms2/ssmoters/car_maint_req_doc_frame.jsp";
	
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	int result = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
%>


<%
	String jung_dt 	= request.getParameter("jung_dt")==null?"":request.getParameter("jung_dt");
	String vid[] 	= request.getParameterValues("ch_cd");
	String vid_num 	= "";
	String m1_no 	= "";
	String seq = "";
	int vid_size = vid.length;
	
	String req_code  = Long.toString(System.currentTimeMillis());
	
	//out.println("���ðǼ�="+vid_size+"<br><br>");
	
	for(int i=0;i < vid_size;i++){
		
		vid_num = vid[i];
		
		m1_no 		= vid_num.substring(0,12);
		
		//1. ����-------------------------------------------------------------------------------------------
		
		flag1 = mc_db.updateCarMaintJungDt(m1_no, jung_dt );
		
		flag2 = mc_db.updateCarmaintReqCode(m1_no, req_code);
	
							
	}
	
	String sub  = "";
	String cont = "";
	String target_id = "";
	String doc_no = "";
	
	String user_id2 = "000026";
	
	//�����忬�� -> ����������, ������, �������忬�� -> ȸ������ڷ� 		
	
	CarScheBean cs_bean2 = csd.getCarScheTodayBean(user_id2);  		
		
	if(!cs_bean2.getWork_id().equals("") ) {	
		user_id2 = "XXXXXX"; //����	
	}		
	
	
	//1. ����ó���� ���-------------------------------------------------------------------------------------------
		
	DocSettleBean doc = new DocSettleBean();
  		
	sub 	= "�ڵ����˻�� ���� ��û";
	cont 	= "[ ��������: "+jung_dt+"] �ڵ����˻�� ������Ǽ� ���縦 ��û�մϴ�.";				
	target_id = "";
		
	doc.setDoc_st("51");// �ڵ����˻�� ���� û��
	doc.setDoc_id(req_code);
	doc.setSub(sub);
	doc.setCont(cont);
	doc.setEtc("");
		
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
	      doc1 = d_db.getDocSettleCommi("51", req_code);
		  doc_no = doc1.getDoc_no();
				
		  flag1 = d_db.updateDocSettleCls(doc_no, "XXXXXX", "2",  "2");		
	}
	
    
	//2. ��޽��� �˶� ���----------------------------------------------------------------------------------------
		
	String url 		= "/fms2/ssmoters/car_maint_req_doc_frame.jsp";
	sub 		= "�ڵ����˻� ���� ��û";
	cont 	= "�ڵ����˻�� ������Ǽ� ���縦 ��û�մϴ�.";
	target_id = "";
		
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
	target_id = doc.getUser_id2();
	
	if (target_id.equals("XXXXXX")) {
			target_id = doc.getUser_id3();
	}	
			
//	target_id = nm_db.getWorkAuthUser("�����������");
		
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
	System.out.println("��޽���(�ڵ����˻� ���������û)"+jung_dt+"-----------------------"+target_bean.getUser_nm());
%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('�ڵ����˻� ���� �����Դϴ�.\n\nȮ���Ͻʽÿ�');					<%		}	%>		
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
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>