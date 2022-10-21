<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*,acar.common.*, acar.user_mng.*" %>
<%@ page import="acar.off_anc.*, acar.car_office.*, acar.car_mst.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="a_bean" class="acar.off_anc.AncBean" scope="page"/>
<jsp:useBean id="f_bean" class="acar.off_anc.Bbs_FBean" scope="page"/>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>

<%
	OffAncDatabase oad = OffAncDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	int bbs_id 		= 0;
	String user_id 	= "";
	String acar_id 	= "";
	String user_nm 	= "";
	String br_id 	= "";
	String br_nm 	= "";
	String dept_id 	= "";
	String dept_nm 	= "";
	String reg_dt 	= "";
	String exp_dt 	= "";
	String title 	= "";
	String content 	= "";
	String read_yn 	= "";
    String auth_rw 	= "";
    String cmd 		= "";
	String bbs_st 	= request.getParameter("bbs_st")==null?"":request.getParameter("bbs_st");
	String p_view 	= "";
	String impor_yn = "";
	String keywords = "";
	String car_comp_id = "";
	String car_cd = "";
	String end_st = "";
	

	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	if(request.getParameter("bbs_id") != null) bbs_id = Util.parseInt(request.getParameter("bbs_id"));

	acar_id = login.getCookieValue(request, "acar_id");

	a_bean = oad.getAncBean(bbs_id);
	
	if(bbs_st == "5"){
		f_bean = oad.getBbs_FBean2(bbs_id);
	}
	
	user_id 	= a_bean.getUser_id();
	user_nm 	= a_bean.getUser_nm();
	dept_nm 	= a_bean.getDept_nm();
	reg_dt 		= a_bean.getReg_dt();
	exp_dt 		= a_bean.getExp_dt();
	title 		= a_bean.getTitle();
	content 	= a_bean.getContent();
	read_yn 	= a_bean.getRead_yn();
	bbs_st 		= a_bean.getBbs_st();
	p_view 		= a_bean.getP_view();
	impor_yn 	= a_bean.getImpor_yn();
	
	keywords 	= a_bean.getKeywords();
	car_comp_id = a_bean.getCar_comp_id();
	car_cd 		= a_bean.getCar_cd();
	end_st 		= a_bean.getEnd_st();

	//�ش�μ� �������Ʈ
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector users = new Vector();
	users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	
	String car_comp_id2	= "0001"; 
	
	if(!car_comp_id.equals("")){
		car_comp_id2	= car_comp_id;
	}
	//�ڵ���ȸ�� ����Ʈ
	CarOfficeDatabase cof = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = cof.getCarCompAll();
	
	//��������Ʈ
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] = cmb.getCarKindAll(car_comp_id2);	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title><%=title%></title>
<!-- <SCRIPT LANGUAGE=JAVASCRIPT SRC="Calendar_1.js"></SCRIPT> -->
<SCRIPT SRC="../lib/ckeditor/ckeditor.js"></SCRIPT>
<SCRIPT LANGUAGE=JAVASCRIPT>

function NowDateCall() {
var NowDay = new Date;
var DDyear = NowDay.getYear();
var DDmonth = NowDay.getMonth() + 1;
var DDday = NowDay.getDate();
if (DDmonth < 10) { DDmonth = "0" + DDmonth; }
if (DDday < 10) { DDday = "0" + DDday; }
AncRegForm.exp_dt.value = DDyear + "-" + DDmonth + "-" + DDday;
}
</SCRIPT>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
	//����Ʈ
	function list(){
		var fm = document.AncUpForm;			
		fm.action = 'anc_s_grid_frame.jsp';		
		fm.target = 'd_content';
		fm.submit();
	}
	
function AncUp()
{
	var theForm = document.AncUpForm;
	if(theForm.title.value == '')		{	alert('������ �Է��Ͻʽÿ�');	return;	}
//	if(theForm.content.value == '')	{	alert('������ �Է��Ͻʽÿ�');	return;	}
	if(theForm.content.value == null)	{	alert('������ �Է��Ͻʽÿ�');	return;	}
//	if(get_length(theForm.content.value) > 4000){
//		alert("4000�� ������ �Է��� �� �ֽ��ϴ�.");
//		return;
//	}	
	theForm.cmd.value = "u";

	if(confirm('�����Ͻðڽ��ϱ�?')){
		document.domain = "amazoncar.co.kr";
		theForm.action='anc_null_ui.jsp';		
		theForm.target="i_no";
		theForm.submit();
	}
}
function AncDl()
{
	var theForm = document.AncUpForm;
	if(!confirm('�����Ͻðڽ��ϱ�?'))
		return;	
	theForm.cmd.value = "d";
	theForm.target="i_no";
	theForm.action = "anc_null_ui.jsp";	
	theForm.submit();
}
function ChangeDT()
{
	var theForm = document.AncUpForm;
	theForm.exp_dt.value = ChangeDate(theForm.exp_dt.value);
}
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
function AncClose()
{
	//opener.parent.c_body.SearchBbs();
	self.close();
	window.close();
}

//����Ʈ ����	
function go_to_list()
{
		var fm = document.AncUpForm;
				
		var auth_rw = fm.auth_rw.value;
	
		location = "anc_s_grid_frame.jsp?auth_rw="+auth_rw;
	
}	
//���÷��� Ÿ��
function cng_est_st2(st) {
	var fm = document.form1;
	if(st == "1"){ 			//���
		est_st3_1.style.display	= '';						
		est_st3_2.style.display	= 'none';		
	}else if(st == "2"){	//����
		est_st3_1.style.display	= 'none';						
		est_st3_2.style.display	= '';		
	}
}


//�ڵ���ȸ�� ���ý� �����ڵ� ����ϱ�
function GetCarCode(){
	var fm = document.AncUpForm;
	var fm2 = document.form2;
	te = fm.code;
	te.options[0].value = '';
	te.options[0].text = '��ȸ��';
	fm2.sel.value = "AncUpForm.code";
	fm2.car_comp_id.value = fm.car_comp_id.value;
	fm2.mode.value = '8';
	fm2.target="i_no";
	fm2.submit();
}


-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<link rel="stylesheet" href="../js/datepicker/jquery-ui.min.css"><!-- date picker c s s 2018.02.06 -->
</head>
<body onLoad="javascript:self.focus()">
<form action="/acar/car_mst/car_mst_null.jsp" name="form2" method="post">
  <input type="hidden" name="sel" value="">
  <input type="hidden" name="car_comp_id" value="">
  <input type="hidden" name="code" value="">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="mode" value="">  
  <input type="hidden" name="from_page" value="/acar/car_mst/car_mst_i.jsp">
</form>
<form  name="AncUpForm" method="post" >


<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td colspan=2>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle border=0>&nbsp;<span class=style1>Master > �������� > <span class=style5>�������׼���</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class=h ></td>
	</tr>
	<tr>
		<td colspan='4' align='right'><a href='javascript:window.close()' onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
			<!--<a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>--></td>
	</tr>
	<tr>
		<td class=line2 ></td>
	</tr>
	<tr>
	<td class='line'>
		<table border="0" cellspacing="1" cellpadding="0" width=100%>
			<tr>
				<td class="title">ī�װ�</td>
				<td colspan="3">
				<INPUT TYPE="radio" NAME="bbs_st" value="1" <%if(a_bean.getBbs_st().equals("1")){%>checked<%}%>	readonly    >�Ϲݰ���&nbsp;&nbsp; 
				<INPUT TYPE="radio" NAME="bbs_st" value="4" <%if(a_bean.getBbs_st().equals("4")){%>checked<%}%>	readonly	>��������&nbsp;&nbsp;
				<INPUT TYPE="radio" NAME="bbs_st" value="5" <%if(a_bean.getBbs_st().equals("5")){%>checked<%}%>	readonly	>������&nbsp;&nbsp;
				<INPUT TYPE="radio" NAME="bbs_st" value="6" <%if(a_bean.getBbs_st().equals("6")){%>checked<%}%>	readonly	>�������λ�&nbsp;&nbsp;
				<INPUT TYPE="radio"	NAME="bbs_st" value="2" <%if(a_bean.getBbs_st().equals("2")){%>checked<%}%>	readonly	>�ֱٴ���&nbsp;&nbsp; 
				<INPUT TYPE="radio" NAME="bbs_st" value="3" <%if(a_bean.getBbs_st().equals("3")){%>checked<%}%>	readonly	>�Ǹ�����&nbsp;&nbsp; 
				<br>
							&nbsp;<%if(user_id.equals(acar_id)||nm_db.getWorkAuthUser("������",acar_id)){%>
							<select name="p_view">
								<option value="" <%if(a_bean.getP_view().equals("")){%>selected<%}%>>����</option>
								<option value="Y" <%if(a_bean.getP_view().equals("Y")){%>selected<%}%> >���¾�ü</option>
								<option value="A" <%if(a_bean.getP_view().equals("A")){%>selected<%}%>>������Ʈ</option>
								<option value="J" <%if(a_bean.getP_view().equals("J")){%>selected<%}%>>���¾�ü/������Ʈ</option>
							</select>&nbsp;(�����¾�ü/������Ʈ�� ������ �� �� �ֵ��� ������ �� �ֽ��ϴ�.)<br><%}%>
				</td>
			</tr>

			<tr>
				<td class="title" >�ۼ���</td>
				<td><%=user_nm%></td>
				<td class="title" >�μ�</td>
				<td><%=dept_nm%></td>
				
			</tr>
			<tr>
				<td class="title" width="72">�ۼ���</td>
				<td width="117"><%=reg_dt%></td>
				<td class="title" width="72">������</td>
				<td width="339" >
				<input type='text' name="exp_dt" id="exp_dt" size='20' class='text' onBlur="javascript:ChangeDT()" value="<%=a_bean.getExp_dt()%>">
				<!-- <IMG onfocus=this.blur() ONCLICK="Calendar(exp_dt);" src="/acar/images/center/button_in_calendar.gif" border=0 align='absmiddle'> -->
				</td>
			</tr>
			
			<%if(ck_acar_id.equals("000029") && a_bean.getBbs_st().equals("3")){
					String car_comp_nm 	= "";
					String car_nm = "";
					if(!a_bean.getCar_comp_id().equals("")){
						car_comp_nm = c_db.getNameById(a_bean.getCar_comp_id(),"CAR_COM");
					}	
					if(!a_bean.getCar_comp_id().equals("") && !a_bean.getCar_cd().equals("")){
						car_nm = c_db.getNameById(a_bean.getCar_comp_id()+""+a_bean.getCar_cd(),"CAR_MNG");
					}	
			%>
			<tr>
				<td class="title" width=15%>��������</td>
				<td colspan='3'>&nbsp;&nbsp;<select name="car_comp_id" onChange="javascript:GetCarCode()">
        		    	<option value="">������ ����</option>
                        <%for(int i=0; i<cc_r.length; i++){
        						        cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>" <%if(car_comp_id.equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        <%	}	%>
                      </select>
                      &nbsp;                      
                      <select name="code">
                        <option value="">���� ����</option>
                        <%if(!car_comp_id.equals("")){ %>
                        <%for(int i=0; i<cm_r.length; i++){
        						        cm_bean = cm_r[i];%>
                        <option value="<%=cm_bean.getCode()%>" <%if(car_cd.equals(cm_bean.getCode()))%>selected<%%>><%=cm_bean.getCar_nm()%></option>
                        <%	}	%>
                        <%}%>
                      </select>
                      &nbsp;                      
                      <select name="end_st" onChange="javascript:GetEndTitle()">
                        <option value="">�ܻ걸�� ����</option>
                        <option value="1" <%if(end_st.equals("1"))%>selected<%%>>�����ܻ�</option>
                        <option value="2" <%if(end_st.equals("2"))%>selected<%%>>����ܻ�</option>
                      </select>
                      </td>
			</tr>
			<%} %>
						
			<%if(a_bean.getBbs_st().equals("5")){%>
			<tr>
				<td class='line' colspan='3'>
					<table border="0" cellspacing="1" cellpadding="0" width="100%">
						<tr>
							<td class="title" width=30%>����</td>
							<td colspan="">
								<INPUT TYPE="radio" NAME="title_st" value="1" <%if(f_bean.getTitle_st().equals("1")){%>checked<%}%>>��ȥ/��&nbsp;
								<INPUT TYPE="radio" NAME="title_st" value="2" <%if(f_bean.getTitle_st().equals("2")){%>checked<%}%>>�ΰ�&nbsp;
								<input type='text' name="title1" id="title1" size='45' class='text'>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class=h></td>
			</tr>
			<tr id="est_st3_1" style="display:none">
				<td class='line'>
					<table border="0" cellspacing="1" cellpadding="0" width="100%">				
						<tbody>
							<tr>
							  <td colspan="1" rowspan="3" class="title" width=15%>�����</td>
							  <td class="title" width=15%>����</td>
							  <td>&nbsp;&nbsp;<select name="d_user_id1">
								<option value="">����</option>
								<%if(user_size > 0){
									for(int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i); %>
								<option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID")))%> selected <%%>><%=user.get("USER_NM")%></option>
								<%	}
								}		%>
							  </select></td>
							</tr>
							<tr>
							  <td class="title" width=15%>�μ�</td>
							  <td>&nbsp;</td>
							</tr>
							<tr>
							  <td class="title" width=15%>��ȭ��ȣ</td>
							  <td></td>
							</tr>
							<tr>
							  <td colspan="1" rowspan="2" class="title" width=15%>����Ͻ�</td>
							  <td class="title" width=15%>����</td>
							  <td>&nbsp;&nbsp;<input type='text' name="d_day_st1" id="d_day_st1" size='60' class='text' value=''></td>
							</tr>
							<tr>
							  <td class="title" width=15%>����</td>
							  <td>&nbsp;&nbsp;<input type='text' name="d_day_ed" id="d_day_ed" size='60' class='text' value=''></td>
							</tr>
							<tr>
							  <td colspan="1" rowspan="3" class="title" width=15%>���</td>
							  <td class="title" width=15%>��Ī</td>
							  <td>&nbsp;&nbsp;<input type='text' name="place_nm1" id="place_nm1" size='60' class='text' value=''></td>
							</tr>
							<tr>
							  <td class="title" width=15%>��ȭ��ȣ</td>
							  <td>&nbsp;&nbsp;<input type='text' name="place_tel1" id="place_tel1" size='60' class='text' value=''></td>
							</tr>
							<tr>
							  <td class="title" width=15%>�ּ�</td>
							  <td>&nbsp;&nbsp;<input type='text' name="place_addr1" id="place_addr1" size='60' class='text' value=''></td>
							</tr>
							<tr>
								<td class="title" colspan="2" width=30%>÷��</td>
								<td colspan="">&nbsp;&nbsp;<textarea name="content1" id="content1" cols='65' rows='7'> </textarea></td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr id="est_st3_2" style="display:none">
				<td class='line'>
					<table border="0" cellspacing="1" cellpadding="0" width="100%">				
						<tbody>
							<tr>
							  <td colspan="1" rowspan="3" class="title" width=15%>�����</td>
							  <td class="title" width=15%>����</td>
							  <td>&nbsp;&nbsp;<select name="d_user_id2">
								<option value="">����</option>
								<%if(user_size > 0){
									for(int i = 0 ; i < user_size ; i++){
										Hashtable user = (Hashtable)users.elementAt(i); %>
								<option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID")))%> selected <%%>><%=user.get("USER_NM")%></option>
								<%	}
								}		%>
							  </select></td>
							</tr>
							<tr>
							  <td class="title" width=15%>�μ�</td>
							  <td></td>
							</tr>
							<tr>
							  <td class="title" width=15%>��ȭ��ȣ</td>
							  <td></td>
							</tr>
							<tr>
							  <td colspan="1" rowspan="3" class="title" width=15%>����</td>
							  <td class="title" width=15%>����</td>
							  <td>&nbsp;&nbsp;<input type='text' name="deceased_nm" id="deceased_nm" size='60' class='text' value=''></td>
							</tr>
							<tr>
							  <td class="title" width=15%>�����Ͻ�</td>
							  <td>&nbsp;&nbsp;<input type='text' name="deceased_day" id="deceased_day" size='60' class='text' value=''></td>
							</tr>
							<tr>
							  <td class="title" width=15%>����</td>
							  <td>&nbsp;&nbsp;<input type='text' name="family_relations" id="family_relations" size='60' class='text' value=''></td>
							</tr>
							<tr>
							  <td colspan="1" rowspan="2" class="title" width=15%>����</td>
							  <td class="title" width=15%>�Ͻ�</td>
							  <td>&nbsp;&nbsp;<input type='text' name="d_day_st2" id="d_day_st2" size='60' class='text' value=''></td>
							</tr>
							<tr>
							  <td class="title" width=15%>���</td>
							  <td>&nbsp;&nbsp;<input type='text' name="d_day_place" id="d_day_place" size='60' class='text' value=''></td>
							</tr>
							<tr>
							  <td colspan="1" rowspan="4" class="title" width=15%>����</td>
							  <td class="title" width=15%>����</td>
							  <td>&nbsp;&nbsp;<input type='text' name="chief_nm" id="chief_nm" size='60' class='text' value=''></td>
							</tr>
							<tr>
							  <td class="title" width=15%>��Ī</td>
							  <td>&nbsp;&nbsp;<input type='text' name="place_nm2" id="place_nm2" size='60' class='text' value=''></td>
							</tr>
							<tr>
							  <td class="title" width=15%>��ȭ��ȣ</td>
							  <td>&nbsp;&nbsp;<input type='text' name="place_tel2" id="place_tel2" size='60' class='text' value=''></td>
							</tr>
							<tr>
							  <td class="title" width=15%>�ּ�</td>
							  <td>&nbsp;&nbsp;<input type='text' name="place_addr2" id="place_addr2" size='60' class='text' value=''></td>
							</tr>
							<tr>
								<td class="title" colspan="2" width=30%>÷��</td>
								<td colspan="">&nbsp;&nbsp;<textarea name="content2" id="content2" cols='65' rows='7'> </textarea></td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<%}else{%>
			<tr>
				<td align="center" class="title">����</td>
			    <td colspan=3>
			    <%if(nm_db.getWorkAuthUser("������",user_id)||nm_db.getWorkAuthUser("�̻�",user_id)||nm_db.getWorkAuthUser("�����ѹ�����",user_id)
		 			||nm_db.getWorkAuthUser("���翵������",user_id)||nm_db.getWorkAuthUser("���翵����ȹ����",user_id)||nm_db.getWorkAuthUser("�����������",user_id)
		 			||nm_db.getWorkAuthUser("���翵��������",user_id)||nm_db.getWorkAuthUser("����",user_id)){ %>
		 			<input type='checkbox' name='impor_yn' value='Y' <%if(impor_yn.equals("Y"))%>checked<%%>>�߿� &nbsp;
		 		<%} %>
			    	<input type='checkbox' name='read_yn' value='Y' <%if(read_yn.equals("Y"))%>checked<%%>>�ʵ�
                	<input type='text' name="title" id="title" value="<%=title%>" size='70' class='text'>
                </td>
			</tr>
			    
			<tr>
				<td class="title">����</td>
				<td colspan="3" align="center"><textarea name="content" cols='80' rows='18'><%=content%></textarea>
					<script>
					CKEDITOR.replace( 'content', {
						toolbar: [
						    { name: 'links', items:['Link']},
						    { name: 'styles', items: [ 'Format', 'Font', 'FontSize' ] },
							{ name: 'basicstyles', items: [ 'Bold', 'Italic' ] },
							{ name: 'insert', items: ['Table','HorizontalRule'] },
							{ name: 'tools', items:['Maximize']}
						],
						height:"300px",
						enterMode: CKEDITOR.ENTER_DIV
					});
					</script>									
				</td>
			</tr>
			<%}%>
			
				<%if(ck_acar_id.equals("000029")){ %>
				<tr>
					<td align="center" class="title" width=15%>Ű����</td>
        		    <td colspan="3">&nbsp;        		    
        		    	<input type='text' name="keywords" id="keywords" size='95' class='text' value='<%=keywords %>' style='IME-MODE: active'>
        		    	�� �޸�(,)�� ����
        		    </td>
        	    </tr>
				<%} %>			
		</table>

	</td>
	</tr>
	<tr>
		<td colspan='4' align='right'><a href="javascript:AncUp()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align=absmiddle border=0></a>
		<a href="javascript:AncDl()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_delete.gif" align=absmiddle border=0></a>&nbsp;
		
		</td>
	</tr>
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
	<input type="hidden" name="bbs_st" value="<%=bbs_st%>">
	<input type="hidden" name="cmd" value="">
		
</table>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="../js/datepicker/jquery-ui.min.js"></script><!-- date picker j s 2018.02.06 -->
<script src="../js/datepicker/datepicker-ko.js"></script><!-- date picker j s 2018.02.06 -->
<script>
	// Ư������ ' " \ ���� 2018.02.06
	var regex = /['"\\]/gi;
	var title;					// ����
	var title1;					// ����
	var content1;			// ÷��
	var content2;			// ÷��
	var d_day_st1;			// ����Ͻ� ����
	var d_day_ed;			// ����Ͻ� ����
	var place_nm1;		// ��� ��Ī
	var place_tel1;			// ��� ��ȭ��ȣ
	var place_addr1;		// �ּ�
	var deceased_nm;	// �ΰ� ���� ����
	var deceased_day;	// �ΰ� ���� �����Ͻ�
	var d_day_st2;			// ���� �Ͻ�
	var family_relations;	// �ΰ� ���ΰ� ����
	var d_day_place;		// ��ʽ��� ���
	var chief_nm;			// ����
	var place_nm2;		// ����Ļ�ȣ
	var place_tel2;			// ��ʽ��� ��ȭ��ȣ
	var place_addr2;		// ��ʽ��� �ּ�
	$("#title").bind("keyup",function(){title = $("#title").val();if(regex.test(title)){$("#title").val(title.replace(regex,""));}});
	$("#title1").bind("keyup",function(){title1 = $("#title1").val();if(regex.test(title1)){$("#title1").val(title1.replace(regex,""));}});
	$("#content1").bind("keyup",function(){content1 = $("#content1").val();if(regex.test(content1)){$("#content1").val(content1.replace(regex,""));}});
	$("#content2").bind("keyup",function(){content2 = $("#content2").val();if(regex.test(content2)){$("#content2").val(content2.replace(regex,""));}});
	$("#d_day_st1").bind("keyup",function(){d_day_st1 = $("#d_day_st1").val();if(regex.test(d_day_st1)){$("#d_day_st1").val(d_day_st1.replace(regex,""));}});
	$("#d_day_ed").bind("keyup",function(){d_day_ed = $("#d_day_ed").val();if(regex.test(d_day_ed)){$("#d_day_ed").val(d_day_ed.replace(regex,""));}});
	$("#place_nm1").bind("keyup",function(){place_nm1 = $("#place_nm1").val();if(regex.test(place_nm1)){$("#place_nm1").val(place_nm1.replace(regex,""));}});
	$("#place_tel1").bind("keyup",function(){place_tel1 = $("#place_tel1").val();if(regex.test(place_tel1)){$("#place_tel1").val(place_tel1.replace(regex,""));}});
	$("#place_addr1").bind("keyup",function(){place_addr1 = $("#place_addr1").val();if(regex.test(place_addr1)){$("#place_addr1").val(place_addr1.replace(regex,""));}});
	$("#deceased_nm").bind("keyup",function(){deceased_nm = $("#deceased_nm").val();if(regex.test(deceased_nm)){$("#deceased_nm").val(deceased_nm.replace(regex,""));}});
	$("#deceased_day").bind("keyup",function(){deceased_day = $("#deceased_day").val();if(regex.test(deceased_day)){$("#deceased_day").val(deceased_day.replace(regex,""));}});
	$("#d_day_st2").bind("keyup",function(){d_day_st2 = $("#d_day_st2").val();if(regex.test(d_day_st2)){$("#d_day_st2").val(d_day_st2.replace(regex,""));}});
	$("#family_relations").bind("keyup",function(){family_relations = $("#family_relations").val();if(regex.test(family_relations)){$("#family_relations").val(family_relations.replace(regex,""));}});
	$("#d_day_place").bind("keyup",function(){d_day_place = $("#d_day_place").val();if(regex.test(d_day_place)){$("#d_day_place").val(d_day_place.replace(regex,""));}});
	$("#chief_nm").bind("keyup",function(){chief_nm = $("#chief_nm").val();if(regex.test(chief_nm)){$("#chief_nm").val(chief_nm.replace(regex,""));}});
	$("#place_nm2").bind("keyup",function(){place_nm2 = $("#place_nm2").val();if(regex.test(place_nm2)){$("#place_nm2").val(place_nm2.replace(regex,""));}});
	$("#place_tel2").bind("keyup",function(){place_tel2 = $("#place_tel2").val();if(regex.test(place_tel2)){$("#place_tel2").val(place_tel2.replace(regex,""));}});
	$("#place_addr2").bind("keyup",function(){place_addr2 = $("#place_addr2").val();if(regex.test(place_addr2)){$("#place_addr2").val(place_addr2.replace(regex,""));}});
	
	$(function(){
		$("#exp_dt").datepicker({
			showOn: "both",
			buttonImage: "/acar/images/center/button_in_calendar.gif",
			buttonImageOnly: true,
			buttonText : "�޷�"
		});
	});
	
</script>
<iframe src="about:blank" name="i_no" width="100" height="100" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
	</form>
</body>
</html>