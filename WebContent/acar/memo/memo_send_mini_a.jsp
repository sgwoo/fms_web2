<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*" %>
<%@ page import="acar.memo.*, acar.coolmsg.*, acar.user_mng.*, tax.*, acar.car_sche.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="memo_db" scope="page" class="acar.memo.Memo_Database"/>
<jsp:useBean id="cm_db" scope="page" class="acar.coolmsg.CoolMsgDatabase"/>

<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	String send_st 	= request.getParameter("send_st")==null?""  :request.getParameter("send_st");
	String title 	= request.getParameter("title")==null?""  	:request.getParameter("title");
	String content 	= request.getParameter("content")==null?""  :request.getParameter("content");
	String temp_content 	= request.getParameter("temp_content")==null?""  :request.getParameter("temp_content");
	String temp_msg 	= request.getParameter("temp_msg")==null?""  :request.getParameter("temp_msg");
	String temp_msg2 	= request.getParameter("temp_msg2")==null?""  :request.getParameter("temp_msg2");
	String rece_id 	= request.getParameter("rece_id")==null?""  :request.getParameter("rece_id");
	String send_id 	= request.getParameter("send_id")==null?ck_acar_id:request.getParameter("send_id");
	String send_phone = request.getParameter("send_phone")==null?""  :request.getParameter("send_phone");
	String add_user_yn = request.getParameter("add_user_yn")==null?""  :request.getParameter("add_user_yn");
	String talk_gubun = request.getParameter("talk_gubun")==null?"":request.getParameter("talk_gubun");	
	
	String agent_emp_nm = request.getParameter("agent_emp_nm")==null?"":request.getParameter("agent_emp_nm");
	String agent_emp_m_tel = request.getParameter("agent_emp_m_tel")==null?"":request.getParameter("agent_emp_m_tel");
	
	String m_title = request.getParameter("m_title")==null?"":request.getParameter("m_title");
	
	String rpt_no = request.getParameter("rpt_no")==null?"":request.getParameter("rpt_no");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String car_num = request.getParameter("car_num")==null?"":request.getParameter("car_num");	
	
	if (car_num.equals("")) {
		car_num = "������ȣ ���Է� �Ǵ� ���� ����";
	}
	
	String reg_est_dt = request.getParameter("reg_est_dt")==null?"":request.getParameter("reg_est_dt");
	
	// �����忡�� ��ǰ�غ��Ȳ���������� ���ʿ����� Ŭ�� �� ���� �޽��� �Ǻ� 2017.11.30
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rbs_arrival = request.getParameter("rbs_arrival")==null?"":request.getParameter("rbs_arrival");
		
	String flag = "";
	boolean flag3 = true;
	boolean flag_arrival_dt = true;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	//����� ���� ��ȸ
	UsersBean target_bean 	= umd.getUsersBean(rece_id);
	UsersBean sender_bean 	= umd.getUsersBean(send_id);	
	
	//�޸�------------------------------------------------------------------------------------------------------
	/*	if(send_st.equals("1")){
		
		MemoBean memo_bn = new MemoBean();
		memo_bn.setSend_id	(send_id);
		memo_bn.setRece_id	(rece_id);
		memo_bn.setTitle	(title);
		memo_bn.setContent	(content);
		
		if(!memo_db.sendMemo(memo_bn)){
			flag = "error";
		}
	
	}else */
	//�޼���------------------------------------------------------------------------------------------------------
	if (send_st.equals("2")) {
		
		String xml_data = "";
		
		xml_data =  "<COOLMSG>"+
		  				"<ALERTMSG>"+
  					"    <BACKIMG>4</BACKIMG>"+
  					"    <MSGTYPE>104</MSGTYPE>"+
  					"    <SUB>"+title+"</SUB>"+
	  				"    <CONT>"+content+"</CONT>"+
 					"    <URL></URL>";
		xml_data += "    <TARGET>"+target_bean.getId()+"</TARGET>";
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
		
		if (!flag3) {
			flag = "error";
		}
		
	//����------------------------------------------------------------------------------------------------------
	} else if (send_st.equals("3")) {
		
		content = content + " -"+sender_bean.getUser_nm()+"-";
		
		int i_msglen = AddUtil.lengthb(content);
		
		String msg_type = "0";
		
		//80�̻��̸� �幮��
		if (i_msglen > 80) {
			msg_type = "5";
		}
		
		if (send_phone.equals("")) {
			send_phone = sender_bean.getUser_m_tel();

			if (!sender_bean.getHot_tel().equals("")) {
				send_phone = sender_bean.getHot_tel();
			}
		}
		
		//������Ʈ ��������ڰ� ������ ���������
		if (!agent_emp_nm.equals("") && !agent_emp_m_tel.equals("")) {

			if (m_title.equals("���� ������ �԰� �뺸")) {
				if (talk_gubun.equals("0")) { //�����ð� ǥ��
					List<String> fieldList = Arrays.asList(rpt_no, firm_nm, car_nm, car_num, sender_bean.getUser_nm());
					at_db.sendMessageReserve("acar0245", fieldList, agent_emp_m_tel, send_phone, null, agent_emp_nm, ck_acar_id);
					
				} else if (talk_gubun.equals("1")) { //�����ð� ��ǥ��
					List<String> fieldList = Arrays.asList(rpt_no, firm_nm, car_nm, car_num, sender_bean.getUser_nm());
					at_db.sendMessageReserve("acar0251", fieldList, agent_emp_m_tel, send_phone, null, agent_emp_nm, ck_acar_id);
					
				} else {
					List<String> fieldList = Arrays.asList(rpt_no, firm_nm, car_nm, car_num, sender_bean.getUser_nm());
					at_db.sendMessageReserve("acar0245", fieldList, agent_emp_m_tel, send_phone, null, agent_emp_nm, ck_acar_id);
					
				}

			} else if (m_title.equals("������� ������ ��û")) {
				if (talk_gubun.equals("0")) { //������� ������ ��û
					List<String> fieldList = Arrays.asList(reg_est_dt, rpt_no, car_nm, sender_bean.getUser_nm());
					at_db.sendMessageReserve("acar0246", fieldList, agent_emp_m_tel, send_phone, null, agent_emp_nm, ck_acar_id);
					
				} else if (talk_gubun.equals("1")) { //�������� ��û
					List<String> fieldList = Arrays.asList(reg_est_dt, rpt_no, car_nm, sender_bean.getUser_nm());
					at_db.sendMessageReserve("acar0250", fieldList, agent_emp_m_tel, send_phone, null, agent_emp_nm, ck_acar_id);
					
				} else {
					List<String> fieldList = Arrays.asList(reg_est_dt, rpt_no, car_nm, sender_bean.getUser_nm());
					at_db.sendMessageReserve("acar0246", fieldList, agent_emp_m_tel, send_phone, null, agent_emp_nm, ck_acar_id);					
				}
				
			} else {
				at_db.sendMessage(1009, "0", content, agent_emp_m_tel, send_phone, null, agent_emp_nm, ck_acar_id);				
			}
			
		//���ʿ�����
		} else {
			
			if (m_title.equals("���� ������ �԰� �뺸")) {
				if (talk_gubun.equals("0")) { //�����ð� ǥ��
					List<String> fieldList = Arrays.asList(rpt_no, firm_nm, car_nm, car_num, sender_bean.getUser_nm());
					at_db.sendMessageReserve("acar0245", fieldList, target_bean.getUser_m_tel(), send_phone, null, target_bean.getUser_nm(), ck_acar_id);
					
				} else if (talk_gubun.equals("1")) { //�����ð� ��ǥ��
					List<String> fieldList = Arrays.asList(rpt_no, firm_nm, car_nm, car_num, sender_bean.getUser_nm());
					at_db.sendMessageReserve("acar0251", fieldList, target_bean.getUser_m_tel(), send_phone, null, target_bean.getUser_nm(), ck_acar_id);
					
				} else {
					List<String> fieldList = Arrays.asList(rpt_no, firm_nm, car_nm, car_num, sender_bean.getUser_nm());
					at_db.sendMessageReserve("acar0245", fieldList, target_bean.getUser_m_tel(), send_phone, null, target_bean.getUser_nm(), ck_acar_id);					
				}
				
			} else if (m_title.equals("������� ������ ��û")) {
				if (talk_gubun.equals("0")) { //������� ������ ��û
					List<String> fieldList = Arrays.asList(reg_est_dt, rpt_no, car_nm, sender_bean.getUser_nm());
					at_db.sendMessageReserve("acar0246", fieldList, target_bean.getUser_m_tel(), send_phone, null, target_bean.getUser_nm(), ck_acar_id);
					
				} else if (talk_gubun.equals("1")) { //�������� ��û
					List<String> fieldList = Arrays.asList(reg_est_dt, rpt_no, car_nm, sender_bean.getUser_nm());
					at_db.sendMessageReserve("acar0250", fieldList, target_bean.getUser_m_tel(), send_phone, null, target_bean.getUser_nm(), ck_acar_id);
					
				} else {
					List<String> fieldList = Arrays.asList(reg_est_dt, rpt_no, car_nm, sender_bean.getUser_nm());
					at_db.sendMessageReserve("acar0246", fieldList, target_bean.getUser_m_tel(), send_phone, null, target_bean.getUser_nm(), ck_acar_id);					
				}
				
			} else {
				at_db.sendMessage(1009, "0", content, target_bean.getUser_m_tel(), send_phone, null, target_bean.getUser_nm(), ck_acar_id);				
			}
		}
		
		//20200528 ���� ������ �԰� �뺸 �϶� ���������(���漱����)���Ե� ���ڸ� ������.
		//20200616 ���漱���� ��û���� �˸��� ��� ��޽��� �߼� �ǵ��� ����.
		if (add_user_yn.equals("Y")) {
			
			UsersBean target_bean2 = umd.getUsersBean(nm_db.getWorkAuthUser("���������"));
			
			CarScheBean cs_bean = csd.getCarScheTodayBean(target_bean2.getUser_id());
			
			if (!cs_bean.getUser_id().equals("")) {
				target_bean2 	= umd.getUsersBean(nm_db.getWorkAuthUser("�������������"));
			}
			
			if (!sender_bean.getUser_nm().equals(target_bean2.getUser_nm()) && !target_bean.getUser_nm().equals(target_bean2.getUser_nm())) {
				
				if (m_title.equals("���� ������ �԰� �뺸")) {
					
					/*
					if (talk_gubun.equals("0")) { //�����ð� ǥ��
						List<String> fieldList = Arrays.asList(rpt_no, firm_nm, car_nm, car_num, sender_bean.getUser_nm());
						at_db.sendMessageReserve("acar0245", fieldList, target_bean2.getUser_m_tel(), send_phone, null, target_bean2.getUser_nm(), ck_acar_id);
						
					} else if (talk_gubun.equals("1")) { //�����ð� ��ǥ��
						List<String> fieldList = Arrays.asList(rpt_no, firm_nm, car_nm, car_num, sender_bean.getUser_nm());
						at_db.sendMessageReserve("acar0251", fieldList, target_bean2.getUser_m_tel(), send_phone, null, target_bean2.getUser_nm(), ck_acar_id);
						
					} else {
						List<String> fieldList = Arrays.asList(rpt_no, firm_nm, car_nm, car_num, sender_bean.getUser_nm());
						at_db.sendMessageReserve("acar0245", fieldList, target_bean2.getUser_m_tel(), send_phone, null, target_bean2.getUser_nm(), ck_acar_id);
						
					}
					*/

					//�����»���� ������ ���� �뱸 ���� �λ� �� ��� �����񾾿��� �޽��� �߼� 
					//���漱 ���� ��û���� �ش� ���� ���� �ּ�ó�� 20200616
					//if (sender_bean.getBr_id().equals("D1") || sender_bean.getBr_id().equals("G1") || sender_bean.getBr_id().equals("J1") || sender_bean.getBr_id().equals("B1")) {
						
					String xml_data2 = "";
					
					if (talk_gubun.equals("0")) { //�����ð� ǥ��
						content = temp_msg;
					} else if (talk_gubun.equals("1")) { //�����ð� ��ǥ��
						content = temp_msg2;
					}
					
					xml_data2 =  "<COOLMSG>"+
					  				"<ALERTMSG>"+
			  					"    <BACKIMG>4</BACKIMG>"+
			  					"    <MSGTYPE>104</MSGTYPE>"+
			  					"    <SUB>"+title+"</SUB>"+
				  				"    <CONT>"+content+"</CONT>"+
			 					"    <URL></URL>";
					xml_data2 += "    <TARGET>2008003</TARGET>";
					xml_data2 += "    <TARGET>2017009</TARGET>";
					xml_data2 += "    <SENDER>"+sender_bean.getId()+"</SENDER>"+
			  					"    <MSGICON>10</MSGICON>"+
			  					"    <MSGSAVE>1</MSGSAVE>"+
			  					"    <LEAVEDMSG>1</LEAVEDMSG>"+
				  				"    <FLDTYPE>1</FLDTYPE>"+
			  					"  </ALERTMSG>"+
			  					"</COOLMSG>";
					
					CdAlertBean msg2 = new CdAlertBean();
					msg2.setFlddata(xml_data2);
					msg2.setFldtype("1");
					
					flag3 = cm_db.insertCoolMsg(msg2);
					
					if (!flag3) {
						flag = "error";
					}
						
					//}
					
				} else if (m_title.equals("������� ������ ��û")) {
					if (talk_gubun.equals("0")) { //������� ������ ��û
						List<String> fieldList = Arrays.asList(reg_est_dt, rpt_no, car_nm, sender_bean.getUser_nm());
						at_db.sendMessageReserve("acar0246", fieldList, target_bean2.getUser_m_tel(), send_phone, null, target_bean2.getUser_nm(), ck_acar_id);
						
					} else if (talk_gubun.equals("1")) { //�������� ��û
						List<String> fieldList = Arrays.asList(reg_est_dt, rpt_no, car_nm, sender_bean.getUser_nm());
						at_db.sendMessageReserve("acar0250", fieldList, target_bean2.getUser_m_tel(), send_phone, null, target_bean2.getUser_nm(), ck_acar_id);
						
					} else {
						List<String> fieldList = Arrays.asList(reg_est_dt, rpt_no, car_nm, sender_bean.getUser_nm());
						at_db.sendMessageReserve("acar0246", fieldList, target_bean2.getUser_m_tel(), send_phone, null, target_bean2.getUser_nm(), ck_acar_id);						
					}
					
				} else {
					at_db.sendMessage(1009, "0", content, target_bean2.getUser_m_tel(), send_phone, null, target_bean2.getUser_nm(), ck_acar_id);					
				}
			}
		}
	}
	
	// �������� > ������� > ��ǰ�غ��Ȳ ���������� ���ʿ����� ���� �� ���ڸ� ������ ��� ó��(���� �ð�)			2017. 12. 11
	//System.out.println("-------------------------------");
	//System.out.println("f_p : "+from_page);
	//System.out.println("r_a : "+rbs_arrival);
	//System.out.println("rent_l_cd : "+rent_l_cd);
	
	if (from_page.equals("/fms2/car_pur/rent_board_frame.jsp")) {
		if (rent_l_cd.length() > 0) {
			if (rbs_arrival.equals("Y")) {
				flag_arrival_dt = a_db.updateArrivalDate(rent_l_cd, 1);
			} else {
				flag_arrival_dt = a_db.updateArrivalDate(rent_l_cd, 0);
			}
		} else {
			System.out.println("[��ǰ�غ��Ȳ ���� ����]rent_l_cd�� ���� ���");
		}
	} else {
		System.out.println("[��ǰ�غ��Ȳ ���� ����]��ǰ�غ��Ȳ �������� from_page�� �ٸ� ���, from_page : " + from_page);
	}
%>
<script language='javascript'>
<%if (flag.equals("error")) {%>
	alert('�����߻�!');
	parent.location='about:blank';
<%} else if (flag_arrival_dt == false) {%>
	alert('�����ð� ��� ����!');
	parent.location='about:blank';
<%} else {%>
	<!-- alert('ó���߽��ϴ�.'); -->
	parent.window.close();
<%}%>
</script>
</body>
</html>
