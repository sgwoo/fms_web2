<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.user_mng.*,acar.watch.*, acar.attend.*, acar.car_sche.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="calendar" class="acar.car_sche.CalendarBean" scope="page"/>	
<jsp:useBean id="aa_db" scope="page" class="acar.attend.AttendDatabase"/>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");

	String reg_dt = "";
	
	String member_id 	= request.getParameter("member_id")==null?"":request.getParameter("member_id"); //������

	String start_year 	= request.getParameter("start_year")==null?"":request.getParameter("start_year");
	String start_month 	= request.getParameter("start_month")==null?"":request.getParameter("start_month");
	String start_day 	= request.getParameter("start_day")==null?"":request.getParameter("start_day");
	
	String watch_ot 	= "";
	String watch_gtext 	= "";
	
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String cm 	= request.getParameter("cm")==null?"":request.getParameter("cm");
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	//�����
	UsersBean user_bean = umd.getUsersBean(member_id);
	reg_dt = AddUtil.getTimeYMDHMS();
	
	Vector vt = wc_db.WatchSche(start_year,start_month,start_day, member_id);
	
	String gj_chk= "";
	String gj_yc = "";
	

%>
<html>
<head><title>FMS</title>

<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript'>
<!--




//��������
function get_length(f) {
	var max_len = f.length;
	var len = 0;
	for(k=0;k<max_len;k++) {
		t = f.charAt(k);
		if (escape(t).length > 4)
			len += 2;
		else
			len++;
	}
	return len;
}


//���
function go_to_list()
{
	var fm = document.form1;
	fm.action = "watch.jsp";
	fm.target = 'd_content';
	fm.submit();
}	

//���
function watch_reg()
{
	var fm = document.form1;
	fm.cmd.value = "i";
	

	fm.action = "watch_in_a.jsp";
	fm.target="i_no";
	fm.submit();
}

//start time in
function st_time_in()
{
	var fm = document.form1;
	fm.cmd.value = "s";

	fm.action='watch_in_a.jsp';		
	fm.target='i_no';
	fm.submit();
}

//end time in
function ed_time_in()
{
	var fm = document.form1;
	fm.cmd.value = "e";

	fm.action='watch_in_a.jsp';		
	fm.target='i_no';
	fm.submit();
}

// ����
function watch_gj()
{
	var fm = document.form1;
	
	fm.cmd.value="gj";
			
		if(confirm('����� �����Ͻðڽ��ϱ�?')){	
			fm.action='watch_in_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}						
}

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type="text/css">
<!--
.style10 {
	font-size: 30px;
	font-family: "����", "�ü�", AppleMyungjo;
	font-weight: bold;
}
-->
</style>
</head>
<body onload="javascript:document.form1.title.focus()">
<form action="watch_in_a.jsp" name="form1" method="post" >
<input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
<input type='hidden' name='user_id' 		value='<%=user_id%>'>
<input type='hidden' name='start_year' 		value='<%=start_year%>'>
<input type='hidden' name='start_month' 	value='<%=start_month%>'>
<input type='hidden' name='start_day' 		value='<%=start_day%>'>        
<input type='hidden' name='user_nm' 		value='<%=user_bean.getUser_nm()%>'>
<input type='hidden' name='member_id' 		value='<%=member_id%>'>
<input type="hidden" name="cmd" 			value="">
<input type="hidden" name="cm" 				value="<%=cm%>">
<table border="0" cellspacing="0" cellpadding="0" width=800>

<%if(vt.size()>0){	            
	for(int j=0; j< vt.size(); j++){
		Hashtable ht = (Hashtable)vt.elementAt(j);
		
		gj_chk = String.valueOf(ht.get("WATCH_SIGN"));
		gj_yc = String.valueOf(ht.get("WATCH_TIME_ED"));
%>	
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td colspan="2" >
			<table width="100%"   border=0 cellpadding=0 cellspacing=0 >
				<tr>
					<td width="80%" align="center" class="style10">�� &nbsp; �� &nbsp; �� &nbsp; ��</td>
					<td width="20%">
						<div align="right">
							<table width=100%  border=1 cellpadding=0 cellspacing=0 >
								<tr>
									<td class="title">����</td>
								</tr>
								<tr>
									<td align="center">
										<table width="76%" height="60" border=0 cellpadding=0 cellspacing=0>
											<tr>
									<% if (cm.equals("s")||cm.equals("s2") ||cm.equals("i1")) { %>
										<td align="center">����������<br>
													�豤��<br>									
									<% } else if (cm.equals("x") ) { %>
												<%if(user_bean.getDept_id().equals("0007")){%>
													<td align="center">�λ�������<br>
													������<br>							
												<%}else if(user_bean.getDept_id().equals("0008")){%>
													<td align="center">����������<br>
													�ڿ���<br>
												<%}else if(user_bean.getDept_id().equals("0010")){%>
													<td align="center">��������<br>
													�̼���<br>
												<%}else if(user_bean.getDept_id().equals("0011")){%>
													<td align="center">�뱸����<br>
													����Ź<br>
												<%}else{%>
													<td align="center">����<br>
													ȫ�浿<br>
												<%}%>
									<% } else if (cm.equals("b") ) { %>											
												<td align="center">�λ�������<br>
													������<br>
									<% } else if (cm.equals("d") ) { %>											
												<td align="center">����������<br>
													�ڿ���<br>
									<% } else if (cm.equals("j") ) { %>											
												<td align="center">��������<br>
													�̼���<br>
									<% } else if (cm.equals("g") ) { %>											
												<td align="center">�뱸����<br>
													����Ź<br>													
									<% } %>				
									<%if(ht.get("WATCH_SIGN").equals("")&&(user_id.equals("000026")||user_id.equals("000052")||user_id.equals("000053")||user_id.equals("000054")||user_id.equals("000096")||user_id.equals("000219"))){%>
													<a href='javascript:watch_gj()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_gj.gif" align=absmiddle border=0></a>
									<%}else{%>
													<%=ht.get("WATCH_SIGN")%>
									<%}%>
									</td><!-- �ڿ��� 000026, ������ 000053, ����Ź 000054, �̼��� 000118 -->
											</tr>
									  </table>              
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>


	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=800>			
				<tr>
					<td width="90" class="title">�ۼ���</td>
					
					<td width="150" align="center"><%if(ht.get("WATCH_CH_NM").equals("")){%><%=ht.get("MEMBER_NM")%><%}else{%><%=ht.get("WATCH_CH_NM")%><%}%></td> 
					<td width="90" class="title"><div align="center">�μ�</div></td>
					<td width="150" align="center"><div align="center"><%=user_bean.getDept_nm()%></div></td>				
					<td width="90" class="title"><div align="center">���� ������</div></td>
					<td width="230" align="center"><div align="center">&nbsp;<%=ht.get("WATCH_AMT")%>��
				<!--	
						<% if(ht.get("WATCH_TIME_ST").equals("") && (ht.get("DAY_NM").equals("�����") || ht.get("DAY_NM").equals("�Ͽ���"))){%>
								
								�ָ� &nbsp; <%=ht.get("WATCH_AMT")%>
						<%}else{%>			
						<%if( ht.get("WATCH_TIME_ST").equals("") && aa_db.getHoliday(start_year+start_month+start_day).equals("")){%>
							&nbsp; 0
						<%}else if(ht.get("WATCH_TIME_ST").equals("") && !aa_db.getHoliday(start_year+start_month+start_day).equals("")){%>
							<%=aa_db.getHoliday(start_year+start_month+start_day)%> &nbsp; <%=ht.get("WATCH_AMT")%>
						<%}else if( !ht.get("WATCH_TIME_ST").equals("") && AddUtil.parseInt(String.valueOf(ht.get("TIME"))) <= 1830 ){%>
							&nbsp;<%=AddUtil.ChangeDate3(String.valueOf(ht.get("WATCH_TIME_ST")))%>&nbsp;&nbsp; <%=ht.get("WATCH_AMT")%>		
						
						<%}else{%><%=AddUtil.ChangeDate3(String.valueOf(ht.get("WATCH_TIME_ST")))%>
							&nbsp;&nbsp; <%=ht.get("WATCH_AMT")%>
						<%}%>
							��
						<%}%> -->
						</div></td>					
				</tr>
<!--				
				<tr>
					<td colspan="3" class="title">�������� �ð�</td>
					<td colspan="3" align="center"> <input type="text" name="watch_time_st" value="<%if(ht.get("WATCH_TIME_ST").equals("")){%><%=reg_dt%><%}else{%><%=ht.get("WATCH_TIME_ST")%><%}%>">&nbsp;&nbsp;&nbsp;<%if(ht.get("WATCH_TIME_ST").equals("")){%><a href='javascript:st_time_in()' border='0' class=copy><img src="/acar/images/center/button_in_reg.gif"  align="absmiddle" border="0"></a><%}else{%><%}%></td>
				</tr>
-->				
				<tr>
					<td colspan="3" class="title">�������� ��û�ð�</td>
					<td colspan="3" align="center"><%=ht.get("WATCH_TIME_ED")%></td>
				</tr>

			</table>
		</td>
	</tr>
			
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td colspan="4"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���˻���</span></td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=800 >
 				<tr>
					<td width="40" rowspan="2" class="title">����</td>
					<td width="250" rowspan="2" class="title">���˻���</td>
					<td colspan="3" class="title">���˰��</td>
					<td width="390" rowspan="2" class="title">����</td>												
				</tr>
				<tr>
		 		    <td width="40" class="title">��ȣ</td>
			        <td width="40" class="title">����</td>
		 		    <td width="40" class="title">�ҷ�</td>
				</tr>
				<tr>
					<td align="center">1</td>
					<td>&nbsp;Server room ���Թ� ���� Ȯ�� </td>
					<td align="center"><input type="radio" name="watch_check1" value="G" <%//if(ht.get("WATCH_CHECK1").equals("G")){%>checked<%//}%>></td>
					<td align="center"><input type="radio" name="watch_check1" value="C" <%//if(ht.get("WATCH_CHECK1").equals("C")){%><%//}%>></td>
					<td align="center"><input type="radio" name="watch_check1" value="B" <%//if(ht.get("WATCH_CHECK1").equals("B")){%><%//}%>></td>
					<td align="center"><input type="text" name="watch_ctext1" size="50"></td>
				</tr>
				<tr>
					<td align="center">2</td>
					<td>&nbsp;���ο� ��ǻ�� �������� ���� </td>
					<td align="center"><input type="radio" name="watch_check2" value="G" <%//if(ht.get("WATCH_CHECK2").equals("G")){%>checked<%//}%>></td>
					<td align="center"><input type="radio" name="watch_check2" value="C" <%//if(ht.get("WATCH_CHECK2").equals("C")){%><%//}%>></td>
					<td align="center"><input type="radio" name="watch_check2" value="B" <%//if(ht.get("WATCH_CHECK2").equals("B")){%><%//}%>></td>
					<td align="center"><input type="text" name="watch_ctext2" size="50"></td>
				</tr>
				<tr>
					<td align="center">3</td>
					<td>&nbsp;â�� ���� ���� </td>
					<td align="center"><input type="radio" name="watch_check3" value="G" <%//if(ht.get("WATCH_CHECK3").equals("G")){%>checked<%//}%>></td>
					<td align="center"><input type="radio" name="watch_check3" value="C" <%//if(ht.get("WATCH_CHECK3").equals("C")){%><%//}%>></td>
					<td align="center"><input type="radio" name="watch_check3" value="B" <%//if(ht.get("WATCH_CHECK3").equals("B")){%><%//}%>></td>
					<td align="center"><input type="text" name="watch_ctext3" size="50"></td>
				</tr>
				<tr>
					<td align="center">4</td>
					<td>&nbsp;��Ÿ �����ⱸ ���� / ���� ���� </td>
					<td align="center"><input type="radio" name="watch_check4" value="G" <%//if(ht.get("WATCH_CHECK4").equals("G")){%>checked<%//}%>></td>
					<td align="center"><input type="radio" name="watch_check4" value="C" <%//if(ht.get("WATCH_CHECK4").equals("C")){%><%//}%>></td>
					<td align="center"><input type="radio" name="watch_check4" value="B" <%//if(ht.get("WATCH_CHECK4").equals("B")){%><%//}%>></td>
					<td align="center"><input type="text" name="watch_ctext4" size="50"></td>
				</tr>
				<tr>
					<td align="center">5</td>
					<td>&nbsp;ȸ�ǽ� / ���� ���̺� �������� </td>
					<td align="center"><input type="radio" name="watch_check5" value="G" <%//if(ht.get("WATCH_CHECK5").equals("G")){%>checked<%//}%>></td>
					<td align="center"><input type="radio" name="watch_check5" value="C" <%//if(ht.get("WATCH_CHECK5").equals("C")){%><%//}%>></td>
					<td align="center"><input type="radio" name="watch_check5" value="B" <%//if(ht.get("WATCH_CHECK5").equals("B")){%><%//}%>></td>
					<td align="center"><input type="text" name="watch_ctext5" size="50"></td>
				</tr>
				<tr>
					<td align="center">6</td>
					<td>&nbsp;��ȭ</td>
					<td align="center"><input type="radio" name="watch_check6" value="G" <%//if(ht.get("WATCH_CHECK6").equals("G")){%>checked<%//}%>></td>
					<td align="center"><input type="radio" name="watch_check6" value="C" <%//if(ht.get("WATCH_CHECK6").equals("C")){%><%//}%>></td>
					<td align="center"><input type="radio" name="watch_check6" value="B" <%//if(ht.get("WATCH_CHECK6").equals("B")){%><%//}%>></td>
					<td align="center"><input type="text" name="watch_ctext6" size="50"></td>
				</tr>
				<tr>
					<td align="center">7</td>
					<td>&nbsp;���Թ� �ð�(���Ƚý���) ��ġ</td>
					<td align="center"><input type="radio" name="watch_check7" value="G" <%//if(ht.get("WATCH_CHECK7").equals("G")){%>checked<%//}%>></td>
					<td align="center"><input type="radio" name="watch_check7" value="C" <%//if(ht.get("WATCH_CHECK7").equals("C")){%><%//}%>></td>
					<td align="center"><input type="radio" name="watch_check7" value="B" <%//if(ht.get("WATCH_CHECK7").equals("B")){%><%//}%>></td>
					<td align="center"><input type="text" name="watch_ctext7" size="50"></td>
				</tr>
				<tr>
					<td align="center">8</td>
					<td>&nbsp;��ǥ��ȭ ����(������) </td>
					<td align="center"><input type="radio" name="watch_check8" value="G" <%//if(ht.get("WATCH_CHECK8").equals("G")){%>checked<%//}%>></td>
					<td align="center"><input type="radio" name="watch_check8" value="C" <%//if(ht.get("WATCH_CHECK8").equals("C")){%><%//}%>></td>
					<td align="center"><input type="radio" name="watch_check8" value="B" <%//if(ht.get("WATCH_CHECK8").equals("B")){%><%//}%>></td>
					<td align="center"><input type="text" name="watch_ctext8" size="50"></td>
				</tr>
				<tr>
					<td align="center">9</td>
					<td>&nbsp;��ǥ��ȭ ����(��������)</td>
					<td align="center"><input type="radio" name="watch_check9" value="G" <%//if(ht.get("WATCH_CHECK9").equals("G")){%>checked<%//}%>></td>
					<td align="center"><input type="radio" name="watch_check9" value="C" <%//if(ht.get("WATCH_CHECK9").equals("C")){%><%//}%>></td>
					<td align="center"><input type="radio" name="watch_check9" value="B" <%//if(ht.get("WATCH_CHECK9").equals("B")){%><%//}%>></td>
					<td align="center"><input type="text" name="watch_ctext9" size="50"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	<!--
	<tr>
		<td colspan="4"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ÿ���޻���</span></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=800 >
 				<tr>
					<td colspan="4" align="center"><textarea name="watch_gtext" cols='120' rows='10' value=""><%=ht.get("WATCH_GTEXT")%></textarea></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h></td>
	</tr>
	-->
	<tr>
		<td colspan="4"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>��Ÿ���޻��� / Ư(��)���� ���</span></td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=800 >
 				<tr>
					<td colspan="4" align="center"><textarea name="watch_ot" cols='120' rows='10' value=""><%=ht.get("WATCH_OT")%></textarea></td>
				</tr>
			</table>
		</td>
	</tr>
<%}
}%>		
	<tr>
		<td colspan='4' align='right'>
		<% if ( gj_chk.equals("") && gj_yc.equals("") ) {%>
			<a href="javascript:watch_reg()"><img src="/acar/images/center/button_ask_gj.gif"  align="absmiddle" border="0"></a>&nbsp;&nbsp;
		<% } %>
			<a href='javascript:window.close();' onMouseOver="window.status=''; return true" ><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"> </a>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0"  frameborder="0" noresize> </iframe>
</body>
</html>