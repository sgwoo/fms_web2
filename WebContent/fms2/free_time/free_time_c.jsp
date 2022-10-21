<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.user_mng.*, acar.doc_settle.*" %>
<%@ page import="acar.car_sche.*,acar.common.*" %>
<%@ page import="acar.schedule.*, acar.attend.*, acar.free_time.*" %>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="ft_db" scope="page" class="acar.free_time.Free_timeDatabase"/>
<jsp:useBean id="u_bean" class="acar.user_mng.UsersBean" scope="page" />
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	LoginBean login = LoginBean.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	CarSchDatabase csd = CarSchDatabase.getInstance();	
	
	String id = "";			
	String user_h_tel ="";
	String user_m_tel ="";
	String br_nm = "";
	String dept_nm = "";
	String user_nm = "";

	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");// ������û��
	
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));
	int seq = request.getParameter("seq")==null?1:Util.parseInt(request.getParameter("seq"));
	String doc_no = request.getParameter("doc_no")==null?"":request.getParameter("doc_no");	
	String doc_st = request.getParameter("doc_st")==null?"":request.getParameter("doc_st");	
	
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");

	String kjs_amt = "";
	String kjs_y_dt = "";
	String kjs_dt = "";
	String kjs_jp = "";
	String kjs_bs_dt = "";
	String kjs_bj_dt = "";
	String kjs_bjc = "";
	String kjs_mng = "";
	
	String cm_check = "";	
			
	String  login_id = request.getParameter("login_id")==null?"":request.getParameter("login_id");  //�α��� id

	login_id = ck_acar_id;
		
	u_bean = umd.getUsersBean(user_id);
	user_nm = u_bean.getUser_nm();
	br_nm = u_bean.getBr_nm();
	dept_nm = u_bean.getDept_nm();

	String dept_id = c_db.getUserDept(user_id);
	
	VacationDatabase v_db = VacationDatabase.getInstance();
	
	 Hashtable ht =  new Hashtable();
	 int re_cnt =  0 ;
	 double d_re_cnt = 0; 
		
	Vector vt = new Vector(); 
	
	
   
	//������볻�� ����
    if (  nm_db.getWorkAuthUser("�ܺΰ�����",user_id) ) {  
    }  else { 		

 	  ht = v_db.getVacation(user_id); 	  
 	  re_cnt = AddUtil.parseInt((String)ht.get("VACATION"))-AddUtil.parseInt((String)ht.get("V_CNT"));
 	//����ó���� ���� ����
	  d_re_cnt = AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU"))+AddUtil.parseDouble((String)ht.get("OV_CNT"));  
			//���������Ȳ
	  vt = v_db.getVacationList(user_id, (String)ht.get("YEAR"));	
	
   }	
		
	//������û����
	Vector vt2 = ft_db.Free_per(user_id, doc_no);
	int vt2_size = vt2.size();
	
	//������û���� - ������
	Vector vt3 = ft_db.Free_item(user_id, doc_no);
	int vt3_size = vt3.size();

	//��ü�ٹ�����
	Hashtable ht3= ft_db.getFree_work(user_id, doc_no);
		
	//����ǰ��
	DocSettleBean doc = d_db.getDocSettleOver_time("21", doc_no);  //doc_no��  free_time�� doc_no doc_settle������ doc_id��
	
	Hashtable ht5 = v_db.getVacationBan(user_id);  //����������Ȳ 
	
	Hashtable ht4 = v_db.getVacationBan2(user_id); //1�⳻ ���� ��Ȳ 
	
	int b_su = 0;
	b_su =   AddUtil.parseInt((String)ht4.get("B2")) - AddUtil.parseInt((String)ht4.get("B1"));
		
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------

	int size = 0;
	
	String content_code = "FREE_TIME";
	String content_seq  = doc_no;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	
	String file_type1 = "";
	String seq1 = "";
	String file_name1 = "";
	
	for(int j=0; j< attach_vt.size(); j++){
		Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
		
		if((content_seq).equals(aht.get("CONTENT_SEQ"))){
			file_name1 = String.valueOf(aht.get("FILE_NAME"));
			file_type1 = String.valueOf(aht.get("FILE_TYPE"));
			seq1 = String.valueOf(aht.get("SEQ"));
		}
	}
	
%>

<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script>

window.onbeforeprint = function(){
	//setCookie();
};

function setCookie(cName, cValue, cMinutes){

 	var expire = new Date();
    expire.setDate(expire.getMinutes() + cMinutes);
    cookies = cName + '=' + escape(cValue) + '; path=/ ; domain=.amazoncar.co.kr';
    if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
    document.cookie = cookies;
    
}

// ��Ű ��������
function getCookie(cName) {
    cName = cName + '=';
    var cookieData = document.cookie;
    var start = cookieData.indexOf(cName);
    var cValue = '';
    if(start != -1){
        start += cName.length;
        var end = cookieData.indexOf(';', start);
        if(end == -1)end = cookieData.length;
        cValue = cookieData.substring(start, end);
    }
    return unescape(cValue);
}

setCookie('tmp_waste', 'delete', 1);

</script>
<script language='javascript'>
<!--
var popObj = null;

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

//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		if( popObj != null ){
			popObj.close();
			popObj = null;
		}
	
		theURL = "https://fms3.amazoncar.co.kr/data/free_time/"+theURL;
		
		popObj = window.open('',winName,features);
		popObj.location = theURL;
		popObj.focus();
	}

/*
function s_check()
{
	var theForm = document.form1;
	
	theForm.cmd.value="sk";
	theForm.s_check.value="Y";

	var inCnt = 0;
	var i = 0;	
	var strOv_yn = "";
	var strMt_yn= "";
	
	inCnt = toInt(theForm.v3_size.value);	
		
	if(inCnt>1){
		for(i=0; i<inCnt ; i++){		
		   strOv_yn =  theForm.ov_yn[i].value;
		   strMt_yn =  theForm.mt_yn[i].value;
		  				   
		   if (strOv_yn == 'Y' && strMt_yn == '' ) {
			   alert('������ ���� ó������� �Է��ϼž� �մϴ�.!!!!.'); 
			   return;
		   }  
		}   
	} else {
	   strOv_yn =  theForm.ov_yn.value;
	   strMt_yn =  theForm.mt_yn.value;
		  				   
	   if (strOv_yn == 'Y' && strMt_yn == '' ) {
		   alert('������ ���� ó������� �Է��ϼž� �մϴ�.!!!!.'); 
		   return;
		}  	
	}	
	
			
	if(confirm('�������� �����Ͻðڽ��ϱ�?')){	
		theForm.action='free_time_sk.jsp';		
		theForm.target='i_no';
		theForm.submit();
	}						
}	
*/

//������� 
function cm_check()
{
	var theForm = document.form1;
	var len = theForm.elements.length;
	var inCnt = 0;
	var i = 0;	
	var strOv_yn = "";
	var strMt_yn= "";
	
	inCnt = toInt(theForm.v3_size.value);	
	
	if(inCnt>1){
		for(i=0; i<inCnt ; i++){		
		   strOv_yn =  theForm.ov_yn[i].value;
		   strMt_yn =  theForm.mt_yn[i].value;
		  				   
		   if (strOv_yn == 'Y' && strMt_yn == '' ) {
			   alert('������ ���� ó������� �Է��ϼž� �մϴ�.!!!!.'); 
			   return;
		   }  
		}   
	} else {
	   strOv_yn =  theForm.ov_yn.value;
	   strMt_yn =  theForm.mt_yn.value;
		  				   
	   if (strOv_yn == 'Y' && strMt_yn == '' ) {
		   alert('������ ���� ó������� �Է��ϼž� �մϴ�.!!!!.'); 
		   return;
		}  	
	}		

	theForm.cmd.value="cm";
	theForm.cm_check.value="Y";
	theForm.doc_bit.value = "7";
	theForm.doc_step.value = "3";
		
	if(confirm('�����Ͻðڽ��ϱ�?')){			

		theForm.action='free_time_sk.jsp';		
		theForm.target='i_no';
		theForm.submit();
	}						
}		


//����ȵȰ� ��������
function cm_check1()
{
	var theForm = document.form1;
	var len = theForm.elements.length;
	var inCnt = 0;
	var i = 0;	
	var strOv_yn = "";
	var strMt_yn= "";
	
	inCnt = toInt(theForm.v3_size.value);	
	
	if(inCnt>1){
		for(i=0; i<inCnt ; i++){		
		   strOv_yn =  theForm.ov_yn[i].value;
		   strMt_yn =  theForm.mt_yn[i].value;
		  				   
		   if (strOv_yn == 'Y' && strMt_yn == '' ) {
			   alert('������ ���� ó������� �Է��ϼž� �մϴ�.!!!!.'); 
			   return;
		   }  
		}   
	} else {
	   strOv_yn =  theForm.ov_yn.value;
	   strMt_yn =  theForm.mt_yn.value;
		  				   
	   if (strOv_yn == 'Y' && strMt_yn == '' ) {
		   alert('������ ���� ó������� �Է��ϼž� �մϴ�.!!!!.'); 
		   return;
		}  	
	}		

	theForm.cmd.value="cm";
	theForm.cm_check.value="Y";
	theForm.doc_bit.value = "7";
	theForm.doc_step.value = "3";
		
	if(confirm('�����Ͻðڽ��ϱ�?')){			

		theForm.action='free_time_sk1.jsp';		
		theForm.target='i_no';
		theForm.submit();
	}						
}		



function free_time_del()
{
	var theForm = document.form1;
	theForm.cmd.value = "d";
		
	if(confirm('�����Ͻðڽ��ϱ�?')){	
			theForm.action='free_time_sk.jsp';		
			theForm.target='i_no';
			theForm.submit();
	}
}

//����Ʈ ����	
function go_to_list()
{
	var fm = document.form1;
	location = "free_time_frame.jsp?ck_acar_id=<%=ck_acar_id%>&s_width=<%=s_width%>&s_height=<%=s_height%>";
	
}

//�˾�����
function open_attend(){
		var SUBWIN="/fms2/free_time/free_time_show.jsp?user_id=<%=user_id%>";	
		window.open(SUBWIN, "open_attend", "left=1000, top=5, width=900, height=430, scrollbars=yes");		
	}


function show_close()
{
	self.close();
}


//�޴� ���� ����
function Email_Set(nm, email){
		var fm = document.form1;
		fm.con_agnt_nm.value 	= nm;
		fm.con_agnt_email.value = email;
}
	
//�߼۸��� �̸�����
function ImEmail_View(user_id){
		var SUBWIN="/mailing/free_time/free_time.jsp?user_id="+user_id;	
		window.open(SUBWIN, "ImEmail_View", "left=150, top=150, width=800, height=650, scrollbars=yes");
}
	
//�̸��Ϻ�����	
function ImEmail_Reg(){
		var fm = document.form1;	
		if(fm.con_agnt_nm.value == '')	{	alert('����ó�� �Է��Ͻʽÿ�.'); return; }
		if(fm.con_agnt_email.value == '')	{	alert('���Ÿ����ּҸ� �Է��Ͻʽÿ�.'); return; }
		if(confirm('���Ϲ߼��� �Ͻðڽ��ϱ�?'))
		{			
			fm.target = "i_no";
			fm.action = "/fms2/free_time/free_email_reg_b.jsp";
			fm.submit();						
		}	
}

function s_cm_check()
{
	var theForm = document.form1;
	
	theForm.cmd.value="s_cm";
	theForm.s_check.value="Y";
		
		if(confirm('�޼��� ������ �Ͻðڽ��ϱ�?')){	
			theForm.action='free_time_sk.jsp';		
			theForm.target='i_no';
			theForm.submit();
		}						
}	

function mt_check()
{
	var theForm = document.form1;
	
	theForm.cmd.value="s_mt";
		
	if(confirm('����ó����� �����Ͻðڽ��ϱ�?')){	
			theForm.action='free_time_sk.jsp';		
			theForm.target='i_no';
			theForm.submit();
	}						
}	

function iwol_check()
{
	var theForm = document.form1;
	
	theForm.cmd.value="iwol";
		
	if(confirm('�̿�ó�� �����Ͻðڽ��ϱ�?')){	
			theForm.action='free_time_sk.jsp';		
			theForm.target='i_no';
			theForm.submit();
	}						
}	

//��ĵ���
	function scan_reg(){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&doc_no=<%=doc_no%>", "SCAN", "left=10, top=10, width=620, height=250, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//������ü�� ����
	function free_time_w_cng(){
		window.open("free_time_work_cng.jsp?user_id=<%=user_id%>&doc_no=<%=doc_no%>", "free_w_cng", "left=100, top=100, width=550, height=250");
	}
	
//-->
</script>
</HEAD>
<body>
<form action="./free_time_u.jsp" name="form1" method="post" >
<input type="hidden" name="user_id" value="<%=user_id%>">	

<input type="hidden" name="s_check" value="">

<input type="hidden" name="cm_check" value="">
<input type='hidden' name="doc_bit" value="">          
<input type='hidden' name="doc_step" value="">
<input type='hidden' name="doc_st" value="21">
<input type='hidden' name="doc_no" value="<%=doc_no %>">    

<input type="hidden" name="year" value="">
<input type="hidden" name="cmd" value="">	
<input type="hidden" name="v3_size" value="<%=vt3_size%>">	

<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<%if(vt2_size > 0){
		for(int i = 0 ; i < vt2_size ; i++){
			Hashtable ht2 = (Hashtable)vt2.elementAt(i); %>	
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > ���°��� > <span class=style5><%= ht2.get("USER_NM") %>�� �ް���û����</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
		<td class=h></td>
	</tr>
	<tr>
		<td align='right'>
		<a href="javascript:go_to_list()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align=absmiddle border=0></a></td>
	</tr>
  
    <!-- ���翩�� ���� -->
    
    <tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="12%" align="center" class="title">ǰ������</td>
					<td align="center" width=14%><%= ht2.get("REG_DT")%></td>					
					<td width="12%" align="center" class="title">�μ���</td>
					<td align="center" width=16%><%= ht2.get("DEPT_NM") %></td>
					<td width="12%" align="center" class="title">�����ȣ</td>
					<td align="center" width=12%><%= ht2.get("ID") %></td>
					<td width="9%" align="center" class="title">����</td>
					<td align="center" width=13%><%= ht2.get("USER_NM") %></td>
					
				</tr>
			</table>
		</td>
	</tr>
	
	
<% if (  nm_db.getWorkAuthUser("�ܺΰ�����",user_id) ) {%>
<% }  else { %>		
	<tr>
	    <td class=h></td>
	</tr>

	
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ��Ȳ</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class="line">
            <table  width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td width=8% rowspan="3" class="title">�ٹ���</td>
                    <td width=8% rowspan="3" class="title">�μ�</td>
                    <td width=6% rowspan="3" class="title">����</td>
                    <td width=8% rowspan="3" class="title">����</td>
                    <td width=8% rowspan="3" class="title">�Ի���</td>                 
                    <td colspan="3" class="title">��ӱٹ��Ⱓ</td>
                    <td colspan="4" class="title" width=20% >�ٷα��ع� ����</td>
                    <td colspan="4" class="title" width=20% >��Ա��� {�̿�(���� 30�� ����)}</td>	
                    <td width="6%" rowspan="3" class="title">���ް���Ȳ<br>����:����</td>
                    <td width=4% rowspan="3" class="title">����</td> 
                </tr>
                <tr> 
                    <td width=4% rowspan="2" class="title">��</td>
                    <td width=4% rowspan="2" class="title">��</td>
                    <td width=4% rowspan="2" class="title">��</td>
                    <td colspan="3" class="title">�����Ȳ</td>
                    <td width=8% rowspan="2" class="title">������</td>
                    <td colspan="3" class="title">�����Ȳ</td>
                    <td width=8% rowspan="2" class="title">�̻�뿬��<br>�Ҹ꿹����</td>                                  		               
                </tr>
                <tr> 
                    <td width=4% class="title">����</td>
                    <td width=4% class="title">���</td>
                    <td width=4% class="title">�̻��</td>
                    <td width=4% class="title">�̿�</td>
                    <td width=4% class="title">���</td>
                    <td width=4% class="title">�̻��</td>                  
                </tr>
                <tr> 
                    <td align="center"><%= ht.get("BR_NM") %></td>
                    <td align="center"><%= ht.get("DEPT_NM") %></td>
                    <td align="center"><%= ht.get("USER_POS") %></td>
                    <td align="center"><%= ht.get("USER_NM") %></td>
                    <td align="center"><%= AddUtil.ChangeDate2((String)ht.get("ENTER_DT")) %></td>
                    <td align="center"><%= ht.get("YEAR") %></td>
                    <td align="center"><%= ht.get("MONTH") %></td>
                    <td align="center"><%= ht.get("DAY") %></td>
                    <td align="center"><b><%= ht.get("VACATION") %></b></td>
                   <td align="center"><font style="color:red;"><b><%= ht.get("SU") %></b></font></td>
                    <td align="center"><font style="color:blue;"><b><%= AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU"))+AddUtil.parseDouble((String)ht.get("OV_CNT")) %></b></font></td>
                  
  <% if ( ht.get("YEAR").equals("0")) { %>
 					<td align="center">&nbsp;</td>      
 <% } else { %>                   
					<td align="center"><%= AddUtil.ChangeDate2((String)ht.get("END_DT")) %></td> 
  <% }  %>                     

					
	<% if ( AddUtil.parseInt(String.valueOf(ht.get("D_90_DT")))   <= AddUtil.parseInt(String.valueOf(ht.get("TODAY"))) ) { %> 		
					<td  width=3% align="center">&nbsp;</td>	 
					<td  width=3% align="center">&nbsp;</td>	 
					<td  width=3% align="center">&nbsp;</td>	
	    			<td  width=7% align="center"><%= AddUtil.ChangeDate2((String)ht.get("C_DUE_DT")) %></td>
<% } else {  %>					
					
	<% if ( String.valueOf(ht.get("REMAIN")).equals("") || String.valueOf(ht.get("REMAIN")).equals("0") || AddUtil.parseInt(String.valueOf(ht.get("DUE_DT")))  <= AddUtil.parseInt(String.valueOf(ht.get("TODAY"))) ) { %> 												
					<td  width=3% align="center">&nbsp;</td>	 
					<td  width=3% align="center">&nbsp;</td>	 
					<td  width=3% align="center">&nbsp;</td>	
					<td  width=3% align="center">&nbsp;</td>	
   <% } else { %>   
   					<td  width=3% align="right"><%= ht.get("REMAIN") %>&nbsp;</td>	 
					<td  width=3% align="right"><%= ht.get("IWOL_SU") %>&nbsp;</td>	 
					<td  width=3% align="right"><%= AddUtil.parseDouble((String)ht.get("REMAIN"))-AddUtil.parseDouble((String)ht.get("IWOL_SU")) %>&nbsp;</td>	 
	    			<td  width=7% align="center"><%= AddUtil.ChangeDate2((String)ht.get("DUE_DT")) %></td>	 
    <% }  %>  
 <% }  %>      
 				  <td width=6% align="center">
						<%if(b_su >= 3){%>
						<font color = 'red'><b>
						<%=AddUtil.parseInt((String)ht4.get("B1"))%> : <%=AddUtil.parseInt((String)ht4.get("B2"))%>
						</font></b>
						<%}else{%>
						<%=AddUtil.parseInt((String)ht4.get("B1"))%> : <%=AddUtil.parseInt((String)ht4.get("B2"))%>
						<%}%>
					</td>	
 				  <td align="center"><% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %><font style="color:red;"><% } %><%= ht.get("OV_CNT") %><% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %></font><% } %></td>
                </tr>
            </table>
        </td>
    </tr>
<% } %>    
    
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���� ��û����</span></td>
    </tr>
	<tr>
	    <td class=line2></td>
	</tr>
   	<tr>
		<td class='line'>
			<table width="100%" border="0" cellpadding="0" cellspacing="1">
              <tr>
                <td width="12%"rowspan="3"  align="center" class="title">����</td>
                <td width="26%" rowspan="3" align="center" class="title">����</td>
                <td colspan="4" align="center" class="title">�ް���û�Ⱓ</td>
                <td colspan="2" align="center" class="title">��ü�ٹ���</td>
              </tr>
              <tr>                        
                <td colspan="2" align="center" class="title">����</td>
                <td colspan="2" align="center" class="title">����</td>
                <td width=14% rowspan="2" align="center" class="title">�μ�</td>
                <td width=12% rowspan="2" align="center" class="title">�̸�</td>
               
              </tr>
              <tr>
                <td width="10%" align="center" class="title">����</td>
                <td width="8%" align="center" class="title">����</td>
                <td width="10%" align="center" class="title">����</td>
                <td width="8%" align="center" class="title">����</td>
              </tr>
              <tr>
                <td align="center" >
                   <% if(ht2.get("SCH_CHK").equals("3")){%>
                    ����                    	
                    <%}else if(ht2.get("SCH_CHK").equals("5")){%>
                    ����
                    <%}else if(ht2.get("SCH_CHK").equals("6")){%>
                    ������
                    <%}else if(ht2.get("SCH_CHK").equals("7")){%>
                    ����
                    <%}else if(ht2.get("SCH_CHK").equals("9")){%>
                    �����ް�
                    <%}else if(ht2.get("SCH_CHK").equals("4")){%>
                    ����ް�
                    <%}else if(ht2.get("SCH_CHK").equals("8")){%>
                    ����
                    <%}%></td> 
              
                <td align="center" ><%=ht2.get("TITLE")%></td>
                <td align="center" ><%=ht2.get("START_DATE")%></td>
                <td align="center" ><%=ht2.get("DAY_NM")%></td>
                <td align="center" ><%=ht2.get("END_DATE")%></td>
                <td align="center" ><%=ht2.get("DAY_NM2")%></td>
                <td align="center" ><%=ht3.get("WORK_DEPT")%></td>
                <td align="center" ><%=ht3.get("WORK_NM")%>
                <!-- 20200422���� -->
                  <%if(doc.getUser_id1().equals(ck_acar_id) || nm_db.getWorkAuthUser("�ӿ�",login_id) || nm_db.getWorkAuthUser("������",login_id) || nm_db.getWorkAuthUser("�λ�������",login_id) || nm_db.getWorkAuthUser("����������",login_id) || nm_db.getWorkAuthUser("������",login_id)){%>
                  <%	if(AddUtil.parseInt(String.valueOf(ht2.get("REG_DT2"))) >= 20200422 && (AddUtil.parseInt(String.valueOf(ht2.get("START_DATE"))) >= AddUtil.getDate2(4) || nm_db.getWorkAuthUser("������",login_id))){%>
                  <a href="javascript:free_time_w_cng()"><img src=/acar/images/center/button_in_modify.gif border=0 align=absmiddle></a>
                  <%	}%>
                  <%}%>
                </td>               
              </tr>
			  <tr>
			  	 <td align="center" class="title">����</td>
			  	 <td colspan=3 align="left">&nbsp;&nbsp;&nbsp;<%=ht2.get("CONTENT")%></td>
			  	 <td align="center" class="title">÷������</td>
			  	 <td colspan=3 align="center">
						<%if(file_name1.equals("")){%>
							<a href="javascript:scan_reg()"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
						<%}else{%>
							<%if(file_type1.equals("image/jpeg")||file_type1.equals("image/pjpeg")||file_type1.equals("application/pdf")){%>
								<a href="javascript:openPopF('<%=file_type1%>','<%=seq1%>');" title='����' ><%=file_name1%></a>
							<%}else{%>
								<a href="https://fms3.amazoncar.co.kr/sample/download.jsp?SEQ=<%=seq1%>" target='_blank'><%=file_name1%></a>
							<%}%>
						 &nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=seq1%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>  
						<%}%>
					
				</td>
			  </tr>
            </table>
        </td>
	</tr>
	
	    
	<tr></tr><tr></tr><tr></tr><tr></tr>	
	
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="12%" align="center" class="title">�༱���ּ�</td>
					<td width="44%"colspan="3">&nbsp;&nbsp;&nbsp;<%=ht2.get("ADDR")%></td>
					<td width="9%" align="center" class="title">�ڵ���</td>
					<td width=35%>&nbsp;&nbsp;&nbsp;<%=ht2.get("USER_M_TEL")%></td>
				</tr>
				
			</table>
		</td>
	</tr>  
	
	

    <tr>
        <td class=h></td>
    </tr>
    
	<tr></tr><tr></tr><tr></tr><tr></tr>	
		
	<tr> 
        <td class="line">
            <table  width=100% border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class="title" width="12%">����</td>
                    <td class="title" width="19%">�ް���������</td>
                    <td class="title" width="18%">����</td>
                    <td class="title" width="17%">�޿�</td>
                    <td class="title" width="34%">ó��</td>
                    
                </tr>
                <% if(vt3.size()>0 ){
                     int a_cnt = 0;
                     int a1_cnt = 0;
        			 for(int k=0; k< vt3.size(); k++){
        				Hashtable sch3 = (Hashtable)vt3.elementAt(k);  
        				
        				if (sch3.get("OV_YN").equals("Y")) {
        				    a_cnt = -1;
        				} else if (sch3.get("OV_YN").equals("N")) {
        				    a_cnt = 0;        				   
        				} else {      
	        				if (!sch3.get("CM_CHECK").equals("Y") || !sch3.get("S_CHECK").equals("Y")) {
	        				//	a_cnt = re_cnt - (k+1);   
	        					a_cnt = (int) d_re_cnt - (k+1);   
	        				}         				
        				}  
        				
        				if (sch3.get("OV_YN").equals("Y")) {
        				} else {
        					if (!ht2.get("SCH_CHK").equals("3")) a_cnt = 0;  //������ �ƴϸ� 
        					
        					if ( sch3.get("OV_YN").equals("N") ) {
        					} else {
        						if (sch3.get("TITLE").equals("��������") || sch3.get("TITLE").equals("���Ĺ���") || sch3.get("TITLE").equals("��������") || sch3.get("TITLE").equals("���Ĺ���") ) {
	        						a_cnt = 0;  //������ �⺻ ���� 	        					
	        					}	
	        					if (ht2.get("SCH_CHK").equals("5")) {
	        						a_cnt = -1;  //������ �⺻ ����	
	        						a1_cnt = -1; 
	        					}	
	        					//����, ������ �޿�����
	        					if (ht2.get("SCH_CHK").equals("8")) {
	        					    a_cnt = -1;  //������ �⺻ ����	
	        					    a1_cnt = -1; 	
	        					}
	        			       }		
        					
        				}
        				 
        				if(sch3.get("MT_YN").equals("1")) {
        				 a1_cnt = -1; 	
        				}       				
        				 
        				if(sch3.get("MT_YN").equals("2")) {
        				 a1_cnt = -2; 	
        				} 
        				
        				// ���α� �������� ����   //
        				if(sch3.get("USER_ID").equals("000177")) {
        					 a_cnt = 0;  //������ ���� 	
        				}	
        			  %>
                <tr> 
                    <td align="center"><%= k+1 %></td>
                    <td align="center">
                    <input type='text' size='11' name='free_dt' value='<%=AddUtil.ChangeDate2((String)sch3.get("FREE_DT")) %>' readonly maxlength='10' class='whitetext'>
                    </td>
                    <td align="center"><%= sch3.get("DAY_NM") %></td> 
                    <td align="center">&nbsp;
                     <select name="ov_yn" >
                        <option value="N" <%if(a_cnt >= 0)%>selected<%%>>����</option>  
                        <option value="Y" <%if(a_cnt < 0)%>selected<%%>>����</option>  					 		           
		              </select>
		              <input type="hidden" value="<%=a_cnt%>" style="width: 50px;">
              
                    </td>
                    <td align="center">
                       <select name="mt_yn" >
                        <option value="" > --����-- </option> 
                        <option value="1" <%if(a_cnt == -1 )%>selected<%%>>�޿�����</option> 
		              </select>              
                     <% if (ck_acar_id.equals("000063")||ck_acar_id.equals("000029")) {%>
                     <a href='javascript:mt_check()' onMouseOver="window.status=''; return true">����ó������   </a>                 
                     <% } %>
                    &nbsp;&nbsp; 
                   <% if (ck_acar_id.equals("000063")||ck_acar_id.equals("000029")) {%>                 
                      <select name="iwol" >
                        <option value="" > --����-- </option> 
                        <option value="Y" >�̿�</option>                      				 		           
		              </select>    
                    &nbsp;<a href='javascript:iwol_check()' onMouseOver="window.status=''; return true">�����̿�����  </a>
                     <% } %>
                    </td>
                </tr>
              	<% } %>
             <% } %>
            </table>
        </td>
    </tr> 

    
   <!-- ������ ��쿡 ���ؼ� -- �ϴ� --> 
   
    <tr>
        <td class=h></td>
    </tr>
<!-- �߰�  -->    
    <tr>
        <td> 

            <%	if( nm_db.getWorkAuthUser("������",login_id)){%>
            <table width=100% border="0" cellspacing="0" cellpadding="0">
                
                <tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�̻�� ���� �뺸 �߼۸���</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr>
                    <td class="line">
                        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                            <tr>
                                <td width='12%' class='title'>�̸�</td>
                                <td>&nbsp;
                                <input type='text' size='15' name='con_agnt_nm' value='<%= ht.get("USER_NM") %>' maxlength='20' class='text'></td>
                            </tr>
                            <tr>
                                <td class='title'>EMAIL</td>
                                <td>&nbsp;
                                <input type='text' size='40' name='con_agnt_email' value='<%= ht.get("USER_EMAIL") %>' maxlength='30' class='text'></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                	<td align="right">
                &nbsp;<a href="javascript:ImEmail_View('<%=ht.get("USER_ID")%>')"><img src=/acar/images/center/button_see_pre.gif border=0 align=absmiddle></a>
                    	<%if(ck_acar_id.equals("000096")){%>
						&nbsp;<a href="javascript:ImEmail_Reg();"><img src=/acar/images/center/button_bh.gif border=0 align=absmiddle></a>
						<%}%>
               	  </td>
                </tr>
                           
            </table>
            
            <%}%>
        </td>
    </tr>
    <tr>
        <td>
            <table width=100% border="0" cellspacing="0" cellpadding="0">
            	<tr>
                    <td class=h></td>
                </tr>
            	<tr> 
                    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������볻��</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class="line">
                        <table  width=100% border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td class="title" width="8%" rowspan=2>����</td>
                                <td class="title" width=14%  colspan=2>����</td> <!-- �̿��� �ִ� ��� 30�ϱ��� ���� -->
                                <td class="title" width="8%" rowspan=2>�޿�</td>
                                <td class="title" width="12%" rowspan=2>�������</td>
                                <td class="title" width="8%" rowspan=2>����</td>
                                <td class="title" width="12%" rowspan=2>�������</td>
                                <td class="title" width="38%" rowspan=2>����</td>   
                            </tr>
                            <tr> 
			                    <td class="title" width=7%>�߻�</td>
			                    <td class="title" width=7%>���</td>                  
			                </tr>
                
                            <% if(vt.size()>0){
                    			 for(int k=0; k< vt.size(); k++){
                    				Hashtable sch = (Hashtable)vt.elementAt(k);
									
                    			  %>
                            <tr> 
                                <td align="center"><%= k+1 %></td>
                                <td align="center"><%if( sch.get("IWOL").equals("Y")){%>�̿� <%} else {%>�ű�<%}%></td>  
			                    <td align="center">
			                    <%if( sch.get("COUNT").equals("B1")){%>���� <%} else if ( sch.get("COUNT").equals("B2")){%>���� <%} else {%>����<%}%> </td>    
                                <td align="center"><%if( sch.get("OV_YN").equals("Y")){%>����<%}else{%>����<%}%></td>                          
                                <td align="center"><%= sch.get("START_YEAR") %>-<%= sch.get("START_MON") %>-<%= sch.get("START_DAY") %></td>
                                <td align="center"><%= sch.get("DAY_NM") %></td> 
                                <td align="center"><%= AddUtil.ChangeDate2((String)sch.get("REG_DT")) %></td>
                                <td align="left">&nbsp;<%= sch.get("TITLE") %> - <%= sch.get("CONTENT") %></td>
                            </tr>
                            <% 	}
                    		  }else{ %>
                            <tr> 
                                <td colspan="8" align="center">��볻���� �����ϴ�.</td>
                            </tr>
                            <% } %>
                        </table>
                    </td>
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
			<table border="0" cellspacing="1" cellpadding="0" width="100%">
				<tr>
					<td width="12%" rowspan="2" class="title">����</td>
					<td width="28%" align="center" class="title">�����</td>
					<td width="26%" align="center" class="title">������/����</td>
					<td align="center" class="title"></td>					
				</tr>
				<tr>
				  <td align="center"><%= ht2.get("USER_NM") %></td>
				  				  
			      <td align="center"><%=c_db.getNameById(doc.getUser_id2(),"USER")%><br><%=doc.getUser_dt2()%>
        			  <%if(doc.getUser_dt2().equals("") && !doc.getUser_id2().equals("XXXXXX")  ){
        			  		String user_id2 = doc.getUser_id2();
        					        			
        					%>
        			  <%	if(user_id2.equals(login_id) || nm_db.getWorkAuthUser("������",login_id)|| nm_db.getWorkAuthUser("������",login_id) ){%>
        			    <a href="javascript:cm_check()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
        			  <%	}%>
        			    <br>&nbsp;
        			  <%}%>
        			  
        			  
        		  </td>  
			      
			      <td align="center">&nbsp;<% if (ck_acar_id.equals("000063") || ck_acar_id.equals("000029")) {%>
			      <a href='javascript:s_cm_check()' onMouseOver="window.status=''; return true">�޼��������� </a>&nbsp;
			           <a href='javascript:cm_check1()' onMouseOver="window.status=''; return true">�������� </a>
			      
			      
			       <% } %></td>
			  </tr>
			</table>
		</td>
	</tr>	
<!-- ���翩�� �� -->
    <tr>
        <td class=h></td>
    </tr>
	
			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
			<input type="hidden" name="login_id" value="<%=login_id%>">
			<input type="hidden" name="dept_id" value="<%=dept_id%>">
			<input type="hidden" name="s_kd" value="<%=s_kd%>">
			<input type="hidden" name="t_wd" value="<%=t_wd%>">
			<input type="hidden" name="s_year" value="<%=s_year%>">
			<input type="hidden" name="s_month" value="<%=s_month%>">
			<input type="hidden" name="s_day" value="<%=s_day%>">			
			<input type="hidden" name="st_dt" value="<%=ht2.get("START_DATE")%>">	
			<input type="hidden" name="end_dt" value="<%=ht2.get("END_DATE")%>">						
			<input type="hidden" name="title" value="<%=ht2.get("TITLE")%>">
			<input type="hidden" name="content" value="<%=ht2.get("CONTENT")%>">
			<input type="hidden" name="sch_chk" value="<%=ht2.get("SCH_CHK")%>">
			<input type="hidden" name="work_id" value="<%=ht2.get("WORK_ID")%>">
	
<%}}%>
	
<%	if(nm_db.getWorkAuthUser("�ӿ�",login_id) || nm_db.getWorkAuthUser("������",login_id) || nm_db.getWorkAuthUser("�λ�������",login_id) || nm_db.getWorkAuthUser("����������",login_id) || nm_db.getWorkAuthUser("������",login_id)){%>
	<tr>
		<td align='right'>&nbsp;
		 <%if(doc.getUser_dt2().equals("")){ %>
			<a href="javascript:free_time_del()"><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>		
		 <%} %>		
		</td>
	</tr>		
<%	}else{%>

	<%	if(doc.getUser_id1().equals(ck_acar_id) && !doc.getUser_id2().equals("XXXXXX") && doc.getUser_dt2().equals("")){%>
    <!-- ����� ������ ����Ϸ��� �����Ҽ� �ִ� -->
	<tr>
		<td align='right'>&nbsp;
			<a href="javascript:free_time_del()"><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>		
		</td>
	</tr>		
<% 		}%>	
<% 	}%>
	
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
