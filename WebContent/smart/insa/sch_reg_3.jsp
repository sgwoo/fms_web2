<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>Mobile_FMS</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /> 

<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Pragma" content="no-cache">
<meta name="robots" content="noindex, nofollow">

<style type="text/css">

/* body ���� �Ӽ� */ 
body,div,ul,li,dl,dt,dd,ol,p,h1,h2,h3,h4,h5,h6,form {margin:0;padding:0}
body {font-family:NanumGothic, '�������';}
ul,ol,dl {list-style:none}
img {border:0;vertical-align:top;}
ul {list-style:none; padding:0; margin:0;}

/* ���̾ƿ� ū�ڽ� �Ӽ� */
#wrap {float:left; margin:0 auto; width:100%; background-color:#dedbcd;}
#header {float:left; width:100%; height:43px; margin-bottom:15px;}
#contents {float:left; width:100%; height:100%}
#footer {float:left; width:100%; height:40px; background:#44402d; margin-top:40px;}

/* �޴������ܵ� */
#gnb_menu {float:left; width:100%; height:100px; margin-left:8px;}
#gnb_menu li{float:left; display:inline; height:100px;}

/* �ΰ� */
#gnb_box {float:left; text-align:middle;  text-shadow:1px 1px 1px #000;  width:100%; height:40px;  background:url(/smart/images/top_bg.gif);}
#gnb_home {float:right; padding:7px 15px 0 15px; valign:middle;}
#gnb_login {float:left; height:34px; padding:11px 0 0 15px; color:#fff; font-weight:bold; text-shadow:1px 1px 1px #000;}
#gnb_login a{text-decoration:none; color:#fff;}
#gnb_right{float:right;}


/* �ձ����̺� ���� */

.roundedBox {position:relative; width:83%; padding:17px; }

    .corner {position:absolute; width:17px; height:17px;}

        .topLeft {top:0; left:0; background-position:-1px -1px;}
        .topRight {top:0; right:0; background-position:-19px -1px;}
        .bottomLeft {bottom:0; left:0; background-position:-1px -19px;}
        .bottomRight {bottom:0; right:0; background-position:-19px -19px;}
        
#type4 {background-color:#fff; border:1px solid #bcb9aa;}
    #type4 .corner {background-image:url(/smart/images/corners-type.gif);}
        #type4 .topLeft {top:-1px;left:-1px;}
        #type4 .topRight {top:-1px; right:-1px;}
        #type4 .bottomLeft {bottom:-1px; left:-1px;}
        #type4 .bottomRight {bottom:-1px; right:-1px;}

/* �������̺� */
.contents_box {width:100%; table-layout:fixed; font-size:13px;}
.contents_box th {color:#282828; height:22px; text-align:left; font-weight:bold;}
.contents_box td {line-height:22px; color:#7f7f7f; font-weight:bold;}
.contents_box td a {line-height:22px; color:#7f7f7f; font-weight:bold;}

.contents_box1 {width:100%; table-layout:fixed; font:13px; margin:5px 0px;}
.contents_box1 th {color:#282828; width:80px; height:22px; text-align:left; font-weight:bold; line-height:24px;}
.contents_box1 td {line-height:24px; color:#7f7f7f; font-weight:bold;}
.contents_box1 td a {line-height:24px; color:#7f7f7f; font-weight:bold;}


/* �������̺� */
#ctitle {float:left; margin:3px 0px 0 4px;  color:#58351e; font-weight:bold; font:14px;}
#ctable {float:left; margin-bottom:10px; width:100%; font-size:0.85em;}
#carrow {float:left; margin:0 0 5px 20px;}


</style>

</head>

<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.attend.*" %>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/smart/cookies.jsp" %> 

<%
	UserMngDatabase umd = UserMngDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	VacationDatabase v_db = VacationDatabase.getInstance();
	
	//��������
	Hashtable ht = v_db.getVacation(user_id);
	
	double  su = 0;
	
	su = AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU"))+AddUtil.parseDouble((String)ht.get("OV_CNT")) ;
				
				
	//���������
	user_bean = umd.getUsersBean(user_id);
	
	//�������Ʈ-��ü������
	Vector users = c_db.getUserSearchList("", user_bean.getDept_id(), "", "Y");//String br_id, String dept_id, String t_wd, String use_yn
	int user_size = users.size();
	
	//�ڵ� ����:�μ���
	CodeBean[] depts = c_db.getCodeAll2("0002", "");
	int dept_size = depts.length;

	//���������Ȳ - ���� 
	//Hashtable ht2 = v_db.getVacationBan(user_id);    
	
	Hashtable ht2 = v_db.getVacationBan2(user_id); //1�⳻ ���� ��Ȳ 
	
	int b_su = 0;
	int b1_su = 0;
	int b2_su = 0;
	
	b1_su = AddUtil.parseInt((String)ht2.get("B1"));
	b2_su = AddUtil.parseInt((String)ht2.get("B2"));
	
	b_su =  b1_su - b2_su;	
	
%>

<style type=text/css>
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #828282;
         font-size: 11px;}
.style2 {color: #ff00ff;
         font-size: 11px;} 
.style3 {color: #727272}
.style4 {color: #ef620c}
.style5 {color: #334ec5;
        font-weight: bold;} 
-->

</style>

<script language='JavaScript' src='/smart/include/common.js'></script>
<script language='javascript'>
<!--
function free_reg()
{
	var fm = document.form1;
	var date = new Date();  
        var day  = date.getDate();  
        var month = date.getMonth() + 1;  
        var year = date.getFullYear();  
        year = (year < 1000) ? year + 1900 : year;  
	if (("" + month).length == 1) { month = "0" + month; } 
	if (("" + day).length == 1) { day = "0" + day; } 
	var today = year + "-"+ month + "-" + day;
	
//	alert(theForm.st_dt.value);
//	alert(year + "-"+ month + "-" + day);

	if(fm.st_dt.value < today){
		alert("���ú��� ���� ��¥�� ����� �� �����ϴ�. ���������� ���� �ּ���!!!");	 
		return;		
	}
	
	if(fm.title1.value == '��������' || fm.title1.value == '���Ĺ���' ){
		if(fm.st_dt.value != fm.end_dt.value){
			alert("���ޱⰣ�� Ȯ���ϼ���..!!!");	 
		  	return;		
		}
		
		 if(toFloat(fm.su.value) <  0.5){
			alert("���������� �����Ͽ� ���޸� ��û�� �� �����ϴ�!!!");	 
		  	return;		
		}
		
	}
	
	//���α� ���� ( 000177)  - 20211213
	<% if(!user_id.equals("000177")){ %>
			
		//�������� 2���̻� ���̽� �Է�üũ - 20211208����
		if ( <%=Math.abs(b_su)%> >= 2) {		
			//���������� ���� ��� - ���Ĺ����� ��� �Ǵ� ���� 
			if ( <%=b_su%> >= 2) {
				if(theForm.title1.value == '��������' ) {
					alert("�������޴� ����� �� �����ϴ�..!!!");	 
				  	return;		
				}
			}	
			
			//���Ĺ����� ���� ��� -���������� ��� �Ǵ� ����
			if ( <%=b_su%> <= -2) {
				if(theForm.title1.value == '���Ĺ���' ) {
					alert("���Ĺ��޴� ����� �� �����ϴ�..!!!");	 
				  	return;		
				}
			}			
		}	
	}	
	
	if(fm.work_id.value == '' || fm.work_id.value == '<%=user_id%>' ){	alert("��ü�ٹ��ڰ� �����̰ų� ���õ��� �ʾҽ��ϴ�. ��ü�ٹ��ڸ� �ٽ� �����Ͻʽÿ�!!");	return;	}
	
//	if(fm.ov_yn.value == ''){	alert("�޿��� �����Ͻʽÿ�.");	return;	}
	if(fm.sch_chk.value == ''){	alert("��з��� �����Ͻʽÿ�.");	return;	}
	if(fm.title1.value == ''){	alert("�ߺз��� �����Ͻʽÿ�.");	return;	}
	if(fm.end_dt.value == ''){	alert("���ڸ� �����Ͻʽÿ�.");	return;	}
	if(fm.st_dt.value == ''){	alert("���ڸ� �����Ͻʽÿ�.");	return;	}		
	if(get_length(fm.content.value) > 4000){alert("4000�� ������ �Է��� �� �ֽ��ϴ�."); return; }

	var s_str = fm.end_dt.value;
	var e_str = fm.st_dt.value;
			
	var s_date =  new Date (s_str.substring(0,4), s_str.substring(5,7), s_str.substring(8,10) );
	var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7), e_str.substring(8,10) );
		
	var diff_date = s_date.getTime() - e_date.getTime();
			
	count = Math.floor(diff_date/(24*60*60*1000));
									
	if ( fm.sch_chk.value == '3' ) {
		if ( count > 15 ) {  
		  	alert("�����Ⱓ�� Ȯ���ϼ���..!!!");	 
		  	return;				
		}
	}	
	
	if ( count < 0 ) {  
	  	alert("�����Ⱓ�� Ȯ���ϼ���..!!!");	 
	  	return;				
	}		
	
	
	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	
	fm.target = "i_no";
	fm.action = "sch_reg_a.jsp";
	fm.submit();
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

	//��������Ʈ
	function GetUsetList(nm){
		var fm = document.form1;
		te = fm.work_id;
		te.options[0].value = '';
		te.options[0].text = '��ȸ��';
		fm.nm.value = "form1."+nm;
		fm.target = "i_no";
		fm.action = "user_null.jsp";
		fm.submit();
	}
	
function date_type_input(dt_st, date_type){
		var fm = document.form1;
		var today = new Date();
		var s_dt = "";		
		var dt = today;
		if(date_type==2){//����			
			dt = new Date(today.valueOf()+(24*60*60*1000));
		}else if(date_type == 3){
			dt = new Date(today.valueOf()+(24*60*60*1000)*2);						
		}else if(date_type == 4){
			dt = new Date(today.valueOf()+(24*60*60*1000)*3);						
		}
		s_dt = String(dt.getFullYear())+"-";
		if(dt.getFullYear()<2000) s_dt = String(dt.getFullYear()+1900)+"-";		
		if((dt.getMonth()+1) < 10) 	s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getMonth()+1)+"-";
		if(dt.getDate() < 10) 		s_dt = s_dt+"0";
		s_dt = s_dt+String(dt.getDate());
		
		if(dt_st==1)		fm.st_dt.value = s_dt;		
		else 				fm.end_dt.value = s_dt;				
	}		
//-->
</script>
<script>
 mArray = new Array("��������","���Ĺ���","����");
 aArray = new Array("�������","��������","�����ް�","��Ÿ"); 
 bArray = new Array("�����ް�"); 
 cArray = new Array("�Ʒ�","����", "�������","�ڰ��ݸ�","�ü��ݸ�"); 
 dArray = new Array("���ΰ�ȥ","�ڳ��ȥ","�θ��ȥ","������ȥ","�θ�ȸ��","�θ���","����ںθ���","����ڻ��","���θ���","����/�ڳ���","��Ÿ"); 
 eArray = new Array("�������","��������"); 
 fArray = new Array("������������","�������������","��Ÿ"); 
 
 function changeSelect(value) {
 	document.all.title.length=1;
  if(value == '3') {
   for(i=0; i<mArray.length; i++) {
    option = new Option(mArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '5') {
   for(i=0; i<aArray.length; i++) {
    option = new Option(aArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '9') {
   for(i=0; i<bArray.length; i++) {
    option = new Option(bArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '7') {
   for(i=0; i<cArray.length; i++) {
    option = new Option(cArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '6') {
   for(i=0; i<dArray.length; i++) {
    option = new Option(dArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '4') {
   for(i=0; i<dArray.length; i++) {
    option = new Option(dArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
  if(value == '8') {
   for(i=0; i<fArray.length; i++) {
    option = new Option(fArray[i]);
    document.all.title.options[i+1] = option;
   }
  }
 }
 
 
function firstChange() {// ��з� ���� ���
 var x = document.form1.sch_chk.options.selectedIndex;//������ �ε���
 var groups=document.form1.sch_chk.options.length;//��з� ����
 var group=new Array(groups);//�迭 ����
 for (i=0; i<groups; i++) {
  group[i]=new Array();
 }//for
 // �ɼ�(<option>) ����
 group[0][0]=new Option("��з��� ���� �����ϼ���","");
 
 group[1][0]=new Option("��������","");
 group[1][1]=new Option("��������","��������");//��� <option value="ss">�Ｚ</option>
 group[1][2]=new Option("���Ĺ���","���Ĺ���");
 group[1][3]=new Option("����","����");

 group[2][0]=new Option("��������","");
 group[2][1]=new Option("�������","�������");
 group[2][2]=new Option("��������","��������");
 group[2][3]=new Option("�����ް�","�����ް�");
 group[2][4]=new Option("��Ÿ","��Ÿ");
 
 group[3][0]=new Option("�����ް�����","");
 group[3][1]=new Option("�����ް�","�����ް�");
  
 group[4][0]=new Option("��������","");
 group[4][1]=new Option("�Ʒ�","�Ʒ�");
 group[4][2]=new Option("����","����");
 group[4][3]=new Option("�������","�������");
 group[4][4]=new Option("�ڰ��ݸ�","�ڰ��ݸ�");
 group[4][5]=new Option("�ü��ݸ�","�ü��ݸ�");
  
 group[5][0]=new Option("�����缱��","");
 group[5][1]=new Option("���ΰ�ȥ","���ΰ�ȥ");
 group[5][2]=new Option("�ڳ��ȥ","�ڳ��ȥ");
 group[5][3]=new Option("�θ��ȥ","�θ��ȥ");
 group[5][4]=new Option("������ȥ","������ȥ");
 group[5][5]=new Option("�θ�ȸ��","�θ�ȸ��");
 group[5][6]=new Option("�θ���","�θ���");
 group[5][7]=new Option("����ںθ���","����ںθ���");
 group[5][8]=new Option("����ڻ��","����ڻ��");
 group[5][9]=new Option("���θ���","���θ���");
 group[5][10]=new Option("����/�ڸŻ��","����/�ڸŻ��");
 group[5][11]=new Option("��Ÿ","��Ÿ");
 
 group[6][0]=new Option("����ް�����","");
 group[6][1]=new Option("�������","�������");
 group[6][2]=new Option("��������","��������");

 group[7][0]=new Option("����","");
 group[7][1]=new Option("������������","������������");
 group[7][2]=new Option("�������������","�������������");
 group[7][3]=new Option("��Ÿ","��Ÿ");

 temp = document.form1.title1;//�ι� ° ����Ʈ ���(<select name=second>)
 for (m = temp.options.length - 1 ; m > 0 ; m--) {//���� �� �����
  temp.options[m]=null
 }
 for (i=0;i<group[x].length;i++){//�� ����
  //��) <option value="ss">�Ｚ</option>
  temp.options[i]=new Option(group[x][i].text,group[x][i].value);
 }
 temp.options[0].selected=true//�ε��� 0��°, ��, ù��° ����
}//firstChange

 
</script>

</head>

<body>
<form name='form1' method='post' action='sch_reg_a.jsp'>
  <input type="hidden" name="nm" value="">
  <input type="hidden" name="su" value="<%=su%>">		

<div id="wrap">
    <div id="header">
        <div id="gnb_box">        	
			<div id="gnb_login">�ް����</div>
			<div id="gnb_home"><a href=/smart/main.jsp><img src=/smart/images/btn_home.gif align=absmiddle /></a></div>
        </div>
    </div>
    <div id="contents">	
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>	
		<div id="ctitle">��������</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th>�ٹ���</th>
							<td><%= ht.get("BR_NM") %></td>
						</tr>
						<tr>
							<th>�μ�</th>
							<td><%= ht.get("DEPT_NM") %></td>
						</tr>			
						<tr>
							<th>����</th>
							<td><%= ht.get("USER_POS") %></td>
						</tr>						
						<tr>
							<th>����</th>
							<td><%= ht.get("USER_NM") %></td>
						</tr>						
						<tr>
							<th>�Ի�����</th>
							<td><%= AddUtil.ChangeDate2((String)ht.get("ENTER_DT")) %></td>
						</tr>
						<tr>
							<th>�ٹ��Ⱓ</th>
							<td><%= ht.get("YEAR") %>�� <%= ht.get("MONTH") %>�� <%= ht.get("DAY") %>��</td>
						</tr>
						<tr>
							<th valign=top>������Ȳ</th>
							<td valign=top>�����ϼ�[<%= ht.get("VACATION") %>]<br>
							���[<%= ht.get("SU") %>] 
							<font color="#990000">�̻��[<%= AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU")) %>]</font> 
							����[<% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %><font style="color:red;"><% } %><%= ht.get("OV_CNT") %><% if ( AddUtil.parseInt((String)ht.get("OV_CNT")) > 0 ) { %></font><% } %>]</td>
						</tr>
						<tr>
							<th>���ް� ��Ȳ</th>
							<td>����[<%=ht2.get("B1")%>]&nbsp;&nbsp;&nbsp;����[<%=ht2.get("B2")%>]</td>
						</tr>
						<tr>
							<th>�����Ҹ���</th>
							<td><font color="#990000"><%= AddUtil.ChangeDate2((String)ht.get("END_DT")) %></font> [<%= ht.get("RE_MONTH") %>����<%= ht.get("RE_DAY") %>�� ����]</td>
						</tr>						
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>						
	</div>
	<div id="contents">	
		<div id="carrow"><img src=/smart/images/arrow.gif /></div>	
		<div id="ctitle">�ް����</div>		
    	<div id="ctable">
	    	<div class="roundedBox" id="type4" style="margin:0 auto;">				
			    <div class="corner topLeft"></div>
			    <div class="corner topRight"></div>
			    <div class="contents_box1">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<th valign=top>�ް�����</th>
							<td valign=top>
							<!--
							<select name='ov_yn' onchange="ffirstChange();" size=1>
									<option value='N'>����</option>
									<option value='Y'>����</option>
							</select>
							-->
							<select name='sch_chk' onchange="firstChange();" size=1>
									<option value=''>��з�����</option>
									<option value='3'>����</option>
									<option value='5'>����</option>
									<option value='9'>�����ް�</option>
									<option value='7'>����</option>
									<option value='6'>������</option>
									<option value='4'>����ް�</option>
									<option value='8'>����</option>
								</select>
								<select name='title1' size=1>
	 							<option value=''>�ߺз�����</option>
								</select>
								<br>
								- �Ʒ��� ������ ����
                    			<br>- �����ް��� ���ټӻ�� �ؿܿ����� ��츸 ����
							</td>
						</tr>			
						<tr>
							<th valign=top>��ü������</th>
							<td valign=top>
							<select name='gubun3' onChange="javascript:GetUsetList('work_id');">
					          <option value=''>��ü</option>
					          <%for(int i = 0 ; i < dept_size ; i++){
									CodeBean dept = depts[i];%>
					          <option value='<%=dept.getCode()%>' <%if(user_bean.getDept_id().equals(dept.getCode())){%>selected<%}%>><%=dept.getNm()%></option>
					          <%	
									}%>
					        </select>
							<select name="work_id">
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' ><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
					  <br>
        			   - ����,�ް�,����,�������϶� : ���ڹ��� ���� ��ü��
							</td>
						</tr>							
						<tr>
							<th>�ް��Ⱓ</th>
							<td>
								<input type="text" name="st_dt" value='' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
								<br>
								<input type='radio' name="date_type1" value='1' onClick="javascript:date_type_input(1,1)">����
								<input type='radio' name="date_type1" value='2' onClick="javascript:date_type_input(1,2)" checked>����
								<input type='radio' name="date_type1" value='3' onClick="javascript:date_type_input(1,3)">��
								<input type='radio' name="date_type1" value='4' onClick="javascript:date_type_input(1,4)">����
								<br>
			        			  ~
			        			<input type="text" name="end_dt" value='' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>	
								<br>  
								<input type='radio' name="date_type2" value='1' onClick="javascript:date_type_input(2,1)">����
								<input type='radio' name="date_type2" value='2' onClick="javascript:date_type_input(2,2)" checked>����			  
								<input type='radio' name="date_type2" value='3' onClick="javascript:date_type_input(2,3)">��
								<input type='radio' name="date_type2" value='4' onClick="javascript:date_type_input(2,4)">����
			       			</td>
						</tr>						
						<tr>
							<th>����</th>
							<td><textarea name='content' rows='9' cols='25' ></textarea></td>
						</tr>
						<tr>
							<td style='height:10px;'></td>
						</tr>
						<tr>
							<th>&nbsp;</th>
							<td valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:free_reg()"><img src='/smart/images/btn_pres.gif' align=absmiddle /></a></td>
						</tr>					
				    </table>
			    </div>
			    <div class="corner bottomLeft"></div>
			    <div class="corner bottomRight"></div>
			</div>
		</div>						
	</div>	
    <div id="footer"></div>  
</div>
</form>
<script language="JavaScript">
<!--
		var s_dt = '<%=AddUtil.ChangeDate2(rs_db.addDay(AddUtil.getDate(),1))%>';
		document.form1.st_dt.value  = s_dt;		
		document.form1.end_dt.value = s_dt;			
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe> 
</body>
</html>
