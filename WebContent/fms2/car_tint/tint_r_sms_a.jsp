<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.tint.*, acar.coolmsg.*, acar.car_sche.*, acar.user_mng.*, acar.memo.*, acar.car_office.*"%>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
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
	
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	String sms_type 	= request.getParameter("sms_type")==null?"":request.getParameter("sms_type");
	
	boolean flag1 = true;
	boolean flag2 = true;
	boolean flag3 = true;
	boolean flag4 = true;
	boolean flag5 = true;
	boolean flag6 = true;
	boolean flag7 = true;
	int result = 0;
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
%>

<%
	Vector vt = t_db.getCarTintCSmsList2(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
	//List<String> str_list = new ArrayList<String>();
	String str_list = "";
	//>>
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		UsersBean target_bean 	= umd.getUsersBean(String.valueOf(ht.get("USER_ID1")));		
		UsersBean sender_bean 	= umd.getUsersBean(user_id);
		
		String sub 		= "��ǰȮ�ο�û";
		String cont 		= "��ǰû��!Ȯ�ιٶ�. Ȯ�οϷ��� ������޵�.["+String.valueOf(ht.get("OFF_NM"))+"]";
		String off_nm = String.valueOf(ht.get("OFF_NM"));
		%>
		<%-- <script type="text/javascript">
			var test = '<%=off_nm%>';
			var i = '<%=i%>';
			alert(i+" : "+test);
		</script> --%>
		<%
		
		
				
		//SMS ���� �߼�-------------------------------------------------------------
		if(!target_bean.getUser_m_tel().equals("") && (sms_type.equals("2") || target_bean.getDept_id().equals("1000"))){
			if(!off_nm.equals("�����ڸ���")){	//��û���� �����ڸ��ƴ� ���ڹ߼� ����(2017.10.13)
				
				String sendphone 	= sender_bean.getUser_m_tel();
				if(!sender_bean.getHot_tel().equals("")){
					sendphone 	= sender_bean.getHot_tel();
				}
				String sendname 	= sender_bean.getUser_nm();
				String destphone 	= target_bean.getUser_m_tel();
				String destname 	= target_bean.getUser_nm();
				
				//������Ʈ ���Ƿ������� ��û
				if(target_bean.getDept_id().equals("1000") && !String.valueOf(ht.get("AGENT_EMP_ID")).equals("")){
					CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(String.valueOf(ht.get("AGENT_EMP_ID")));
					destname 	= a_coe_bean.getEmp_nm();
					destphone = a_coe_bean.getEmp_m_tel();
				}
				
			
				str_list += ((((((destphone+"@")+String.valueOf(ht.get("OFF_NM"))) + "@")+destname)+"@")+sendname+"@")+String.valueOf(ht.get("UN_COUNT"))+"//";				
				//���� ��� �ҽ�
				
				
			}else{
				
			}
		}
		//��Ȯ������ ������Ʈ�� ������ ������,�ǿ�Ŀ��Ե� �޽��� ������
		if(sms_type.equals("1") || target_bean.getDept_id().equals("1000")){
			if(!off_nm.equals("�����ڸ���")){	//��û���� �����ڸ��ƴ� ���ڹ߼� ����(2017.10.13)
				
				if(target_bean.getDept_id().equals("1000")){
					sub  = "������Ʈ ��ǰȮ�ο�û";
					cont = target_bean.getUser_nm()+" ������Ʈ ��ǰ ��Ȯ�ΰ��� �ֽ��ϴ�. Ȯ�ο�û �ٶ��ϴ�. "+cont;
				}
				
				//��޽��� �޼��� ����-----------------------------------------------------
				String xml_data = "";
				xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
	  					"    <BACKIMG>4</BACKIMG>"+
	  					"    <MSGTYPE>104</MSGTYPE>"+
	  					"    <SUB>"+sub+"</SUB>"+
		  				"    <CONT>"+cont+"</CONT>"+
	 					"    <URL></URL>";
	 					
	 			if(sms_type.equals("1")){
					xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
	 			}else{
					UsersBean target_bean1 	= umd.getUsersBean(nm_db.getWorkAuthUser("������Ʈ����2"));//���ؼ�(20180601)
					//UsersBean target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("������Ʈ����"));//���缮(20180601)
					//UsersBean target_bean3 	= umd.getUsersBean(nm_db.getWorkAuthUser("������Ʈ����3"));//��μ�(20190102)
					xml_data += "    <TARGET>"+target_bean1.getId()+"</TARGET>";
					//xml_data += "    <TARGET>"+target_bean2.getId()+"</TARGET>";
					//xml_data += "    <TARGET>"+target_bean3.getId()+"</TARGET>";
	 			}
	 			
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
				flag3 = cm_db.insertCoolMsg(msg);
			}else{
			}
		}
	}
	
	Map<String, Integer> countMap = new HashMap<>();
	
	String[] text_arr = str_list.split("//");
	String check_text = "";
	List<String> resultList = new ArrayList<>();
	for(int i=0; i<text_arr.length;i++){
		check_text += text_arr[i];
		resultList.add(String.valueOf(text_arr[i]));
	}
	
	/* str_list.forEach(e -> {
	    Integer count = countMap.get(e);
	    countMap.put(e, count == null ? 1 : count + 1);
	}); */
	/* for(int e=0; e <str_list.size(); e++){
		Integer count = countMap.get(e);
	    countMap.put(String.valueOf(e), count == null ? 1 : count + 1);
	} */
	//System.out.println("countMap >> " + countMap);
	/* countMap.forEach((k, v) -> {
	    List<String> list = new ArrayList<>();
	    for (int i = 0; i < v; i++)
	        list.add(k);
	    resultList.add(list);
	}); */
	
	
	
	String destphone_off_nm = "";
	String split_destphone = "";	// �޴� ��� ��ȭ��ȣ
	String split_off_nm = "";		// ��ǰ ��ü��
	String split_destname = "";	// ������ ��� ����		
	String split_sendname = "";	// �޴� ��� ����
	String split_un_count = "";	// ��Ȯ�� �� ��
	
	if(!check_text.equals("")){
		for(int a=0; a<resultList.size(); a++){
			destphone_off_nm = resultList.get(a);
		//	destphone_off_nm = resultList.get(a).get(0);
			if(destphone_off_nm.length()<=0){
				flag7 = false;	
			}else{
				split_destphone = destphone_off_nm.split("@")[0];
				split_destphone = split_destphone.replaceAll("[-+.^:,]", "");
				split_off_nm = destphone_off_nm.split("@")[1];
				split_destname = destphone_off_nm.split("@")[2];
				split_sendname = destphone_off_nm.split("@")[3];
				split_un_count = destphone_off_nm.split("@")[4];
				
			//	List<String> fieldList = Arrays.asList(split_off_nm, String.valueOf(resultList.get(a).size()));
			//	List<String> fieldList = Arrays.asList(split_off_nm, String.valueOf(text_arr.length+1));
				List<String> fieldList = Arrays.asList(split_off_nm, split_un_count);
				
				// �˸���
				flag7 = at_db.sendMessageReserve("acar0137", fieldList, split_destphone, "02-392-4243", null, split_destname, split_sendname);
			}
		}
	}
	
	%>
<script language='javascript'>
<%		if(!flag1){	%>	alert('��ǰ ���� �����Դϴ�.\n\nȮ���Ͻʽÿ�');					<%		}	%>
<%		if(!flag7){	%>	alert('�˸��� �߼� �����Դϴ�.\n\n�����ڿ��� �������ּ���');	<%		}	%>
</script>

<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name="mode" 	value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>"> 
</form>
<script language='javascript'>
	var fm = document.form1;	
	fm.action = '<%=from_page%>';
	fm.target = 'd_content';
	fm.submit();
</script>
</body>
</html>