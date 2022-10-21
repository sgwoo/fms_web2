<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.io.*, java.util.*, acar.cont.*, acar.common.*, acar.call.*, acar.util.*, acar.coolmsg.*,  acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="p_db" scope="page" class="acar.call.PollDatabase"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
</head>
<body leftmargin="15">
<% 
	String m_id = request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd");		 
	String gubun = request.getParameter("gubun");
	int flag1 = 0;
	int flag2 = 0;
	boolean flag21 = true;
	boolean flag22 = true;
		
	int count = 0;
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String answer_dt = "";
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	//�α��� ���������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");

	//���:������
	ContBaseBean base1 = a_db.getContBaseAll(m_id, l_cd);
	String rent_st = base1.getRent_st();
	String bus_st = base1.getBus_st();  //6:������ü
	
	if (rent_st.equals("2")) {
		rent_st = "5";
	} else if (rent_st.equals("7")) {	
		rent_st = "6";
	}
	
	if (rent_st.equals("6") &&	bus_st.equals("6")) {
		rent_st = "8";   // �縮�� ������ü
	}
	
	//live_poll����
    Vector vt_live = p_db.getPollAll(rent_st, "A", "A");
	//Vector vt_live = p_db.getPollAll();
 	int vt_live_size = vt_live.size();
 

	//1. �ݼ��� ����-----------------------------------------------------------------------------------------------
    //�ű� or ����
    count = p_db.checkContCall(m_id, l_cd);
    
    if (count > 0) {
		answer_dt = p_db.getAnswerDate(m_id, l_cd);
   		// if(!p_db.deleteContCall(m_id, l_cd)) flag1+=1;
    }
    
	String poll_st = request.getParameter("poll_st")==null?"":request.getParameter("poll_st");
	String poll_id = request.getParameter("poll_id")==null?"":request.getParameter("poll_id");
	String rent_dt = request.getParameter("rent_dt")==null?"":request.getParameter("rent_dt");

	Vector polls = p_db.getSurvey_Play_Q(poll_st, rent_dt);
	int poll_size = polls.size();
	
   	/* ContCall insert */
	for (int i = 0; i < poll_size; i++) {
	
		String a_value = request.getParameter("answer"+(i+1));
			
		String b_value[] = request.getParameterValues("answer"+(i+1));
		int b_value_size = b_value.length;
		
		String result = "";
		for (int z = 0; z < b_value_size; z++) {
			result += b_value[z];
			if (z < b_value.length - 1) {				
				result += "/";
			}
		}
	
		ContCallBean base = new ContCallBean();

		base.setPoll_s_id(AddUtil.parseDigit(request.getParameter("poll_s_id")));
		base.setRent_mng_id(request.getParameter("m_id"));
		base.setRent_l_cd(request.getParameter("l_cd"));
		base.setPoll_id(AddUtil.parseDigit(request.getParameter("poll_seq"+(i+1))));		
  		base.setReg_id(user_id);

		if (cmd.equals("i")) {
			/* base.setAnswer		(a_value);
			base.setAnswer_rem	(request.getParameter("answer_rem"+ (i+1) + AddUtil.parseDigit(a_value) )); */			
			base.setAnswer(result);
			base.setAnswer_rem(request.getParameter("answer_rem"+ (i+1) + AddUtil.parseDigit(result) )==null?"":request.getParameter("answer_rem"+ (i+1) + AddUtil.parseDigit(result) ));
			
			if (!p_db.insertContCall(base, answer_dt)) {
				flag1+=1;
			}
			
		} else if (cmd.equals("u")) {
			/* base.setAnswer		(a_value);
			base.setAnswer_rem	(request.getParameter("answer_rem"+ (i+1) + AddUtil.parseDigit(a_value) )); */
			base.setAnswer(result);
			base.setAnswer_rem(request.getParameter("answer_rem"+ (i+1) + AddUtil.parseDigit(result) )==null?"":request.getParameter("answer_rem"+ (i+1) + AddUtil.parseDigit(result) ));
			
			if(!p_db.updateCont_Call(base, answer_dt)){
				flag1+=1;
			}
			
		} else if (cmd.equals("no")) {
			base.setAnswer("N");
			base.setAnswer_rem("");
			
			if (!p_db.insertContCall(base, answer_dt)) {
				flag1+=1;
			}
			
		}
		
		/* System.out.println("poll_st >>> " + poll_st);
		System.out.println("poll_size >>> " + poll_size);
		System.out.println("base.getPoll_id() >>> " + base.getPoll_id());
		System.out.println("base.getPoll_s_id() >>> " + base.getPoll_s_id());
		System.out.println("base.getAnswer() >>> " + base.getAnswer());
		System.out.println("##################################"); */
		
		// ��������� ������ ������ �Ʒ��� ����. 
		// "���Ҹ��� �����ؼ� ��ǥ���� ������ȭ�� ���Ͻó���?"
		// ������ �������� "�׷���"�� ������ ���
		if (cmd.equals("i")) {			
			if (base.getPoll_id() == poll_size) {
				if (base.getAnswer().equals("1")) {
					
					UsersBean sender_bean = umd.getUsersBean(user_id);
					CdAlertBean msg1 = new CdAlertBean();
					CdAlertBean msg2 = new CdAlertBean();
					
					String sub = "[��ǥ���� ������ȭ] ���";
					String cont 	= "[��ǥ���� ������ȭ] ����ȣ  "+l_cd+" �� ���� ���� �����Ͽ� ��ǥ���� ������ȭ�� �ٶ��ϴ�.";
					String url = "/fms2/survey/call_cond_frame.jsp";
					
					String xml_data = "";
					String xml_data2 = "";
					
					//if (poll_st.equals("�ű�") || poll_st.equals("����") || poll_st.equals("����")) {
					//��������
					xml_data = "<COOLMSG>"+
										"<ALERTMSG>"+
						  				"    <BACKIMG>4</BACKIMG>"+
						  				"    <MSGTYPE>104</MSGTYPE>"+
						  				"    <SUB>"+sub+"</SUB>"+
						  				"    <CONT>"+cont+"</CONT>"+
						 				"    <URL>http://fms1.amazoncar.co.kr/fms2/coolmsg/cool_index.jsp?id=%ID&pass=%PASS&url="+url+"</URL>";				 
					xml_data += "   <TARGET>2002011</TARGET>"; //��������
					xml_data += "   <TARGET>2000001</TARGET>"; //��ǥ�̻� 
					xml_data += "     <SENDER>"+sender_bean.getId()+"</SENDER>"+
						  				"    <MSGICON>10</MSGICON>"+
						  				"    <MSGSAVE>1</MSGSAVE>"+
						  				"    <LEAVEDMSG>1</LEAVEDMSG>"+
						  				"    <FLDTYPE>1</FLDTYPE>"+
						  				"</ALERTMSG>"+
						  				"</COOLMSG>";
					
					msg1.setFlddata(xml_data);
					msg1.setFldtype("1");
					
					flag21 = cm_db.insertCoolMsg(msg1);
									
					System.out.println("��޽���(�ݼ�Ÿ ��ǥ�̻� ��ȭ��� )"+ l_cd  +"--------------------- �������� ");
					System.out.println("��޽���(�ݼ�Ÿ ��ǥ�̻� ��ȭ��� )"+ l_cd  +"--------------------- ��ǥ�̻� ");
					//}
				}		
			}	
		}
	}
		
	if (!p_db.updateContCallYes(m_id, l_cd)) {
		flag1 += 1;
	}
		
	//5. �˻�---------------------------------------------------------------------------------------------------

	String use_yn = request.getParameter("use_yn");
	String auth_rw = request.getParameter("auth_rw");
	String s_kd = request.getParameter("s_kd");
	String brch_id 	= request.getParameter("brch_id");
	String s_bank	= request.getParameter("s_bank");
	String t_wd = request.getParameter("t_wd");
	String cont_st = request.getParameter("cont_st");
	String b_lst = request.getParameter("b_lst");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
%>
<script language='javascript'>
<%if (flag1 != 0) {%>
	alert('�����Դϴ�.\n\n��ϵ��� �ʾҽ��ϴ�');
	location='about:blank';
<%} else {%>
	alert("����Ǿ����ϴ�");
	<%if (cmd.equals("no")) {%>
		parent.parent.location = "rent_cond_frame.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&cont_st=<%=cont_st%>";
	<%} else {%>
		parent.parent.location='survey_cont_reg_frame.jsp?mode=2&m_id=<%=m_id%>&l_cd=<%=l_cd%>&auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&brch_id=<%=brch_id%>&s_bank=<%=s_bank%>&t_wd=<%=t_wd%>&use_yn=<%=use_yn%>&cont_st=<%=cont_st%>&b_lst=<%=b_lst%>&poll_st=<%=poll_st%>&rent_dt=<%=rent_dt%>&from_page=<%=from_page%>';
	<%}%>
<%}%>
</script>
</body>
</html>
