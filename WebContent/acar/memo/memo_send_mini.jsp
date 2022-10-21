<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*" %>
<%@ page import="acar.car_office.*, acar.kakao.*" %>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>

<jsp:useBean id="atp_db" class="acar.kakao.AlimTemplateDatabase" scope="page"/>
<jsp:useBean id="atl_db" class="acar.kakao.AlimTalkLogDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String send_id = request.getParameter("send_id")==null?"":request.getParameter("send_id");
	String rece_id = request.getParameter("rece_id")==null?"":request.getParameter("rece_id");
	String m_title = request.getParameter("m_title")==null?"":request.getParameter("m_title");
	String m_content = request.getParameter("m_content")==null?"":request.getParameter("m_content");
	String talk_gubun = request.getParameter("talk_gubun")==null?"0":request.getParameter("talk_gubun");
	
	String rpt_no = request.getParameter("rpt_no")==null?"":request.getParameter("rpt_no");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");
	String car_num = request.getParameter("car_num")==null?"":request.getParameter("car_num");	
	String reg_est_dt = request.getParameter("reg_est_dt")==null?"":request.getParameter("reg_est_dt");
	
	String agent_emp_nm = request.getParameter("agent_emp_nm")==null?"":request.getParameter("agent_emp_nm");
	String agent_emp_m_tel = request.getParameter("agent_emp_m_tel")==null?"":request.getParameter("agent_emp_m_tel");
	
	// �����忡�� ��ǰ�غ��Ȳ���������� ���ʿ����� Ŭ�� �� ���� �޽��� �Ǻ� 2017.11.30
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	UsersBean sender_bean 	= umd.getUsersBean(send_id);
	
	UsersBean rece_bean 	= umd.getUsersBean(rece_id);
	
	//�˸��� ���� �߰�
	String msg = "";
	String msg2 = "";
	ArrayList<String> fieldList = new ArrayList<String>();
	ArrayList<String> fieldList2 = new ArrayList<String>();
	
	if (m_title.equals("���� ������ �԰� �뺸")) {
		
		fieldList.add(rpt_no);
		fieldList.add(firm_nm);
		fieldList.add(car_nm);
		
		if (car_num.equals("")) {
			fieldList.add("������ȣ ���Է� �Ǵ� ���� ����");
		} else {
			fieldList.add(car_num);
		}
		
		fieldList.add(sender_bean.getUser_nm());
		
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar0245");
		String content = templateBean.getContent();
		for (String field : fieldList) {
			content = content.replaceFirst("\\#\\{.*?\\}", field);
		}
		
		msg = content;
		
		fieldList2.add(rpt_no);
		fieldList2.add(firm_nm);
		fieldList2.add(car_nm);
		
		if (car_num.equals("")) {
			fieldList2.add("������ȣ ���Է� �Ǵ� ���� ����");
		} else {
			fieldList2.add(car_num);
		}
		
		fieldList2.add(sender_bean.getUser_nm());
		
		AlimTemplateBean templateBean2 = atp_db.selectTemplate("acar0251");
		String content2 = templateBean2.getContent();
		for (String field2 : fieldList2) {
			content2 = content2.replaceFirst("\\#\\{.*?\\}", field2);
		}
		
		msg2 = content2;
		
	} else if (m_title.equals("������� ������ ��û")) {
		
		fieldList.add(reg_est_dt);
		fieldList.add(rpt_no);
		fieldList.add(car_nm);
		fieldList.add(sender_bean.getUser_nm());
		
		AlimTemplateBean templateBean = atp_db.selectTemplate("acar0246");
		String content = templateBean.getContent();
		for (String field : fieldList) {
			content = content.replaceFirst("\\#\\{.*?\\}", field);
		}
		
		msg = content;
		
		fieldList2.add(reg_est_dt);
		fieldList2.add(rpt_no);
		fieldList2.add(car_nm);
		fieldList2.add(sender_bean.getUser_nm());
		
		AlimTemplateBean templateBean2 = atp_db.selectTemplate("acar0250");
		String content2 = templateBean2.getContent();
		for (String field2 : fieldList2) {
			content2 = content2.replaceFirst("\\#\\{.*?\\}", field2);
		}
		
		msg2 = content2;
		
	}
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP"); //��������� ����Ʈ
	int user_size = users.size();
	
	String rent_mng_id = "";
	
	CommiBean emp2;
	
	// ������ڿ��� ������ ���� ��û ���� ������ 2018.01.16
	if (m_title.equals("������� ������ ��û")) {
		rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
		from_page = "no";
		
		emp2 = a_db.getCommi(rent_mng_id, rent_l_cd, "2");
		agent_emp_nm = emp2.getEmp_nm();
		agent_emp_m_tel = emp2.getEmp_m_tel();
		
		if (agent_emp_m_tel.length() > 10) { // �����Ǹ����� ���(��ȭ��ȣ�� ���� ���) ���ڸ� ���� �� �� ����.
			rece_id = emp2.getEmp_id();
		}
		
		String contArr[] = m_content.split("@");
		if (contArr.length > 2) {
			m_content = contArr[0];
			m_content += "�� ��Ͽ�����\n�� ";
			m_content += contArr[1];
			m_content += " ";
			m_content += contArr[2];
			m_content += "\n�������� 11�� 20�б��� �ѽ�(0505-920-9876)�� �����ֽñ� �ٶ��ϴ�. �ð����� �������� �������� ���� ������ ����� �������� �̷����ϴ�.\n�����մϴ�.";			
		}		
	}
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function send_memo() {
	fm = document.form1;

	if (fm.rece_id.value == '')		{	alert('�޴»���� �Է��Ͻʽÿ�');		fm.rece_id.focus();		return;	}
	if (fm.title.value == '')			{	alert('������ �Է��Ͻʽÿ�');			fm.title.focus();			return;	}
	if (fm.content.value == '')	{	alert('������ �Է��Ͻʽÿ�');			fm.content.focus();		return;	}

	if (get_length(fm.content.value) > 4000) {
		alert("2000�� ������ �Է��� �� �ֽ��ϴ�.");
		return;
	}
	
	if (!confirm("�����ðڽ��ϱ�?")) { return; }
	fm.action='memo_send_mini_a.jsp';
	fm.target="i_no";
	fm.submit();
}

function change_memo(gubun) {
	
	var fm = document.form1;
	
	var m_title = "<%=m_title%>";
	
	fm.talk_gubun.value = "0";
	
	if (m_title == "���� ������ �԰� �뺸") {
		if (gubun == "2") {
			fm.content.value = fm.temp_content.value;
			fm.content.readOnly = false;
			if (m_title == "���� ������ �԰� �뺸") {
				document.getElementById("talk_gubun_style").style.display = "none";
			}
			
		} else if (gubun == "3") {
			fm.content.value = fm.temp_msg.value;
			fm.content.readOnly = true;
			if (m_title == "���� ������ �԰� �뺸") {
				document.getElementById("talk_gubun_style").style.display = "";
			}
		}
	} else if (m_title == "������� ������ ��û") {
		if (gubun == "2") {
			fm.content.value = fm.temp_content.value;
			fm.content.readOnly = false;
			if (m_title == "������� ������ ��û") {
				document.getElementById("talk_gubun_style").style.display = "none";
			}
			
		} else if (gubun == "3") {
			fm.content.value = fm.temp_msg.value;
			fm.content.readOnly = true;
			if (m_title == "������� ������ ��û") {
				document.getElementById("talk_gubun_style").style.display = "";
			}
		}
	} else {
		fm.content.value = fm.temp_content.value;
		fm.content.readOnly = false;
	}
}

function change_talk() {
	var fm = document.form1;
	
	var m_title = "<%=m_title%>";	
	var talk_gubun = fm.talk_gubun.value;
	
	if (m_title == "���� ������ �԰� �뺸") {
		if (talk_gubun == "0") {
			fm.title.value = "���� ������ �԰� �뺸";
			fm.content.value = fm.temp_msg.value;
			fm.content.readOnly = true;
		} else if (talk_gubun == "1") {
			fm.title.value = "���� ������ �԰� �뺸";
			fm.content.value = fm.temp_msg2.value;
			fm.content.readOnly = true;
		}
	} else if (m_title == "������� ������ ��û") {
		if (talk_gubun == "0") {
			fm.title.value = "������� ������ ��û";
			fm.content.value = fm.temp_msg.value;
			fm.content.readOnly = true;
		} else if (talk_gubun == "1") {
			fm.title.value = "�������� ��û";
			fm.content.value = fm.temp_msg2.value;
			fm.content.readOnly = true;
		}
	}
	
}
//-->
</script>
</head>
<body onLoad="javascript:self.focus()">
<form action="" name="form1" method="post">
<input type="hidden" name="send_id" value="<%=send_id%>">
<input type="hidden" name="cmd" value="">
<input type="hidden" name="agent_emp_nm" value="<%=agent_emp_nm%>">
<input type="hidden" name="agent_emp_m_tel" value="<%=agent_emp_m_tel%>">
<input type="hidden" name="from_page" value="<%=from_page%>">
<input type="hidden" name="rent_l_cd" value="<%=rent_l_cd%>">

<input type="hidden" name="m_title" value="<%=m_title%>">

<input type="hidden" name="rpt_no" value="<%=rpt_no%>">
<input type="hidden" name="firm_nm" value="<%=firm_nm%>">
<input type="hidden" name="car_nm" value="<%=car_nm%>">
<input type="hidden" name="car_num" value="<%=car_num%>">
<input type="hidden" name="reg_est_dt" value="<%=reg_est_dt%>">

<table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1> �޸��� > <span class=style5> �����޸� ����</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
   	<tr>
		<td class=line2></td>
	</tr>
    <tr> 
        <td class='line'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class="title" width="100">�˸����</td>
                    <td>&nbsp;
					<%//if(!rece_id.equals("000178")&&!rece_id.equals("000179")&&!rece_id.equals("000180")&&!rece_id.equals("000181")&&!rece_id.equals("000182")&&!rece_id.equals("000183")&&!rece_id.equals("000184")&&!rece_id.equals("000186")){%>
					<%if (!rece_bean.getDept_id().equals("1000")) {%>
						<%if (!m_title.equals("������� ������ ��û")) {%>
        				<input type='radio' id="send_st_1" name="send_st" value='2' onchange="javascript:change_memo('2');">
        				<label for="send_st_1">��޽��� �޽���</label>
						<%}%>
					<%}%>
        				<input type='radio' id="send_st_2" name="send_st" value='3' <%if (m_title.equals("���� ������ �԰� �뺸") || m_title.equals("����������� ������� �߻�") || m_title.equals("������� ������ ��û")|| m_title.equals("�������� �������� �˸�")) {%>checked<%}%> onchange="javascript:change_memo('3');">
        				<label for="send_st_2">SMS ����</label>
					 </td>
                </tr>
                <tr>
                    <td class="title" width="100">�޴»��</td>
                    <td>&nbsp;
                    	<%if((m_title.equals("���� ������ �԰� �뺸") || m_title.equals("����������� ������� �߻�")) && !agent_emp_nm.equals("") && !agent_emp_m_tel.equals("")){%>
                    	<input type="hidden" name="rece_id" value="<%=rece_id%>">
                    	����������� <%=agent_emp_nm%>&nbsp;<%=agent_emp_m_tel%>
                    	<%}else if(m_title.equals("������� ������ ��û")){%>
                    	<input type="hidden" name="rece_id" value="<%=rece_id%>">
                    	������� <%=agent_emp_nm%>&nbsp;<%=agent_emp_m_tel%>
                    	<%}else{%>
						<select name="rece_id">
        			    	<option value="">����</option>
                        	<%if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        	<option value='<%=user.get("USER_ID")%>' <%if(rece_id.equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        	<%	}
        					}		%>
                    	</select>
                    	<%}%>
                    </td>
                </tr>		
                <tr> 
                    <td class="title" width="100">����</td>
                    <td>&nbsp;
						<input type="text" name="title" size="60" class=text value='<%=m_title%>'> 
		    		</td>
                </tr>
                <%if (m_title.equals("���� ������ �԰� �뺸")) {%>
                <tr> 
                    <td class="title" width="100">���������</td>
                    <td>&nbsp;
					<label><input type="checkbox" name="add_user_yn" value="Y" checked> ��������ڿ��Ե� ���ڸ� ������.</label></td>
                </tr>               
                <%}%>
                <%if (from_page.equals("/fms2/car_pur/rent_board_frame.jsp")) {%><!-- �������� > ������� > ��ǰ�غ��Ȳ ���������� ���ʿ����� Ŭ�� �� ���� �޽��� ���� ��� 2017.11.30 -->
                <tr>
                	<td class="title" width="100">����</td>
                	<td>&nbsp;
                	<label><input type="checkbox" name="rbs_arrival" value="Y" checked> �����忡 ������ �������� �˸���.</label></td>
                </tr>
                <%}%>
                <%if (m_title.equals("���� ������ �԰� �뺸") || m_title.equals("������� ������ ��û")) {%>
                <tr id="talk_gubun_style"> 
                    <td class="title" width="100">�˸��� ����</td>
                    <td>
                    	&nbsp;
                    	<select id="talk_gubun" class="talk_gubun" name="talk_gubun" onchange="javascript:change_talk();">
                   		<%if (m_title.equals("���� ������ �԰� �뺸")) {%>
                    		<option value="0" <%if (talk_gubun.equals("0")) {%>selected<%}%>>���� ������ �԰� �뺸(�����ð� ǥ��)</option>
                    		<option value="1" <%if (talk_gubun.equals("1")) {%>selected<%}%>>���� ������ �԰� �뺸(�����ð� ��ǥ��)</option>
                   		<%} else if (m_title.equals("������� ������ ��û")) {%>
                    		<option value="0" <%if (talk_gubun.equals("0")) {%>selected<%}%>>������� ������ ��û</option>
                    		<option value="1" <%if (talk_gubun.equals("1")) {%>selected<%}%>>�������� ��û</option>
                   		<%}%>
                    	</select>
					</td>
                </tr>
                <%}%>
                <tr> 
                    <td class="title">����</td>
                    <td>&nbsp;
                    	<%if (m_title.equals("���� ������ �԰� �뺸") || m_title.equals("������� ������ ��û")) {%>
							<textarea name="content" cols='60' rows='9' style="resize: none;" readonly><%=msg%></textarea>
                    	<%} else {%>
							<textarea name="content" cols='60' rows='9' style="resize: none;"><%=m_content%></textarea>
                    	<%}%>
						<%-- <textarea name="content" cols='60' rows='9'><%=m_content%></textarea> --%>
                    	<input type="hidden" name="temp_content" value="<%=m_content%>">
                    	<input type="hidden" name="temp_msg" value="<%=msg%>">
                    	<input type="hidden" name="temp_msg2" value="<%=msg2%>">
					</td>
                </tr>
                <tr>
                    <td class="title" width="100">ȸ�Ź�ȣ</td>
                    <td>&nbsp;
						<select name="send_phone">
						<%if (!sender_bean.getHot_tel().equals("")) {%>
							<option value="<%=sender_bean.getHot_tel()%>">������ȭ : <%=sender_bean.getHot_tel()%></option>
						<%}%>
		        			<option value="<%=sender_bean.getUser_m_tel()%>">��&nbsp;��&nbsp;��&nbsp; : <%=sender_bean.getUser_m_tel()%></option>        			
		        			<option value="<%=sender_bean.getUser_h_tel()%>">��ǥ��ȭ : <%=sender_bean.getHot_tel()%></option>
	                   	</select>
	                   	&nbsp;(�����϶�)
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td align="center"><a href="javascript:send_memo();"><img src=../images/center/button_memo_send.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <!--
    <tr>
        <td>* ��޽��� ����Ϲ��� ������� ����Ʈ�� �޽����� �Ͽ����ϴ�.</td>
    </tr>
    -->
    <tr>
        <td>* ���ڴ� 80byte �ʰ��ÿ� �幮�ڷ� �߼۵˴ϴ�.</td>
    </tr>	
    <tr>
        <td>* ���ڹ߼۽� [����]�� [-�����»���̸�-]�� �پ �����ϴ�.</td>
    </tr>	
	<%if (!rece_id.equals("")) {%>
		<%if (!m_title.equals("������� ������ ��û")) {%>
		<tr>
	        <td>* �޴»���� ������ �� �ֽ��ϴ�. ����� ���� ���� �˸°� �����Ͻʽÿ�.</td>
	    </tr>
		<%}%>
	<%}%>
	<%if (!m_content.equals("")) {%>
		<%if (m_title.equals("���� ������ �԰� �뺸")) {%>
	    <tr>
	        <td>* ��޽��� �޽��� ���ýÿ��� ������ ������ �� �ֽ��ϴ�.</td>
	    </tr>
	    <tr>
	        <td>* SMS ���� ���ý� �˸������� ����ʿ� ���� ������ ������ �� �����ϴ�.</td>
	    </tr>
		<%} else if (m_title.equals("������� ������ ��û")) {%>
	    <tr>
	        <td>* SMS ���� ���ý� �˸������� ����ʿ� ���� ������ ������ �� �����ϴ�.</td>
	    </tr>
		<%} else {%>
	    <tr>
	        <td>* ������ ������ �� �ֽ��ϴ�.</td>
	    </tr>
		<%}%>
	<%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
