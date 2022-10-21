<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.free_time.*,acar.common.*, acar.user_mng.*" %>
<%@ page import="acar.schedule.*, acar.attend.*" %>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����	
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	String chk1 = request.getParameter("chk1")==null?"d":request.getParameter("chk1");	
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");	
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");	
	int s_year = request.getParameter("s_year")==null?AddUtil.getDate2(1):Integer.parseInt(request.getParameter("s_year"));	
	int s_month = request.getParameter("s_month")==null?AddUtil.getDate2(2):Integer.parseInt(request.getParameter("s_month"));	
	int s_day = request.getParameter("s_day")==null?AddUtil.getDate2(3):Integer.parseInt(request.getParameter("s_day"));
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");	
	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");	
	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String title = "";	
	String title1 = "";	
	String sch_file = "";	
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//�ش�μ� �������Ʈ
	Vector users = new Vector();

	users = c_db.getUserList("", "", "EMP");

	int user_size = users.size();
	
	VacationDatabase v_db = VacationDatabase.getInstance();
	
	//������볻�� ����
	Hashtable ht = v_db.getVacation(ck_acar_id);
	double  su = 0;
	
	su = AddUtil.parseDouble((String)ht.get("VACATION"))-AddUtil.parseDouble((String)ht.get("SU"))+AddUtil.parseDouble((String)ht.get("OV_CNT")) ;
				
	st_dt = Util.getDate();
	
	
	Hashtable ht4 = v_db.getVacationBan2(ck_acar_id); //1�⳻ ���� ��Ȳ 
	
	int b_su = 0;
	int b1_su = 0;
	int b2_su = 0;
	
	b1_su = AddUtil.parseInt((String)ht4.get("B1"));
	b2_su = AddUtil.parseInt((String)ht4.get("B2"));
	
	b_su =  b1_su - b2_su;	
//	b_su =  Math.abs(b2_su - b1_su);

	
	
%>

<HTML>
<HEAD>
<TITLE>�������</TITLE>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
function free_reg()
{
	var theForm = document.form1;
	 var date = new Date();  
         var day  = date.getDate();  
         var month = date.getMonth() + 1;  
         var year = date.getYear();  
         year = (year < 1000) ? year + 1900 : year;  
	if (("" + month).length == 1) { month = "0" + month; } 
	if (("" + day).length == 1) { day = "0" + day; } 
	var today = year + "-"+ month + "-" + day;
	
	var rr_cnt = 0;	
	
		
	<%if(!ck_acar_id.equals("000096")){%>
		if(theForm.st_dt.value != "2016-05-20"){
			if (theForm.dept_id.value != "0005") {
				if(theForm.st_dt.value < today){
					alert("���ú��� ���� ��¥�� ����� �� �����ϴ�. ���������� ���� �ּ���!!!");
					return;
				}
			}
		}
	<%}%>
	
	if(theForm.user_id.value == ''){	alert("����� �����Ͻʽÿ�.");	return;	}
	
	//���α� ���� ( 000177)  - 20211213
	if ( theForm.user_id.value != '000177' ) {
		if(theForm.title1.value == '��������' || theForm.title1.value == '���Ĺ���' ){
			if(theForm.st_dt.value != theForm.end_dt.value){
				alert("���ޱⰣ�� Ȯ���ϼ���..!!!");	 
			  	return;		
			}
			// ������ ����� �븮, ������ �븮, �ɺ�ȣ �븮 ���� ���� ���� ����, ���� ������ �ݹ��� �븮�� �߰��� ��!
			<%if(nm_db.getWorkAuthUser("�ܺΰ�����",ck_acar_id)){}else{%>
		        if(toFloat(theForm.su.value) <  0.5){
				alert("���������� �����Ͽ� ���޸� ��û�� �� �����ϴ�!!!");
			  	return;
			}
		    <%}%>
		}
			
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
	}   //���α�����

//	if(theForm.user_id.value == ''){	alert("����� �����Ͻʽÿ�.");	return;	}
//	if(theForm.sch_chk.value != '8' && theForm.work_id.value == '' || theForm.work_id.value == theForm.user_id.value ){	alert("��ü�ٹ��ڰ� �����̰ų� ���õ��� �ʾҽ��ϴ�. ��ü�ٹ��ڸ� �ٽ� �����Ͻʽÿ�!!");	return;	}
	if(theForm.st_dt.value != "2017-10-02") {
		if(theForm.work_id.value == '' || theForm.work_id.value == theForm.user_id.value ){	alert("��ü�ٹ��ڰ� �����̰ų� ���õ��� �ʾҽ��ϴ�. ��ü�ٹ��ڸ� �ٽ� �����Ͻʽÿ�!!");	return;	}
	}
	if(theForm.title1.value == ''){	alert("�ߺз��� �����Ͻʽÿ�.");	return;	}
	if(get_length(theForm.content.value) > 4000){alert("4000�� ������ �Է��� �� �ֽ��ϴ�."); return; }
	
	var s_str = theForm.end_dt.value;
	var e_str = theForm.st_dt.value;
			
	var s_date =  new Date (s_str.substring(0,4), s_str.substring(5,7), s_str.substring(8,10) );
	var e_date =  new Date (e_str.substring(0,4), e_str.substring(5,7), e_str.substring(8,10) );
		
	var diff_date = s_date.getTime() - e_date.getTime();
			
	count = Math.floor(diff_date/(24*60*60*1000));
									
	if ( theForm.sch_chk.value == '3' ) {
		if ( count > 25 ) {  
		  	alert("�����Ⱓ�� Ȯ���ϼ���..!!!");	 
		  	return;				
		}
	}	
	
	if ( count < 0 ) {  
	  	alert("�����Ⱓ�� Ȯ���ϼ���..!!!");	 
	  	return;				
	}		
	
	if(theForm.title1.value == '�ü��ݸ�' || theForm.title1.value == '�ڰ��ݸ�'  || theForm.title1.value == '�������' ){
	 	alert("���� ��� �� �� �����ϴ�...!!!");	 
	  	return;		
		
	}
		
	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	
	theForm.cmd.value = "i";
	theForm.target = "i_no";
	theForm.action = "free_time_a.jsp";	
	theForm.submit();
}

function free_close()
{
	var theForm = opener.document.form1;
	theForm.submit();
	self.close();
	window.close();
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

//����,����,��,���� ����
function date_type_input(dt_st, date_type){
		var fm = document.form1;
		var today = new Date();
		var s_dt = "";		
		var dt = today;
		if(date_type==5){
			fm.st_dt.value = "";
			fm.end_dt.value = "";
		}else{
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
	}		
	
	
//-->
</script>
<script>
 mArray = new Array("��������","���Ĺ���","����");
 aArray = new Array("�������","��������","�����ް�","��Ÿ"); 
 bArray = new Array("�����ް�"); 
 cArray = new Array("�Ʒ�","����","�������","�ڰ��ݸ�","�ü��ݸ�"); 
 dArray = new Array("���ΰ�ȥ","�ڳ��ȥ","�θ��ȥ","������ȥ","�θ�ȸ��","�θ���","����ںθ���","����ڻ��","���θ���","����/�ڳ���","��Ÿ"); 
 eArray = new Array("�������","��������"); 
 fArray = new Array("������������","�������������", "��Ÿ"); 
 
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

 group[7][0]=new Option("��������","");
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

 //��ü�ٹ��� ��ȸ�ϱ�
	function User_search(dept_id)
	{
		var fm = document.form1;
		if(fm.user_id.value == ''){		alert("������� �����Ͻʽÿ�.");	return;	}
		if(fm.sch_chk.value == ''){		alert("��з��� �����Ͻʽÿ�.");	return;	}
		if(fm.title1.value == ''){		alert("�ߺз��� �����Ͻʽÿ�.");	return;	}
		if(fm.st_dt.value == ''){		alert("�ް��Ⱓ�� �Է��Ͻʽÿ�.");	return;	}
		if(fm.end_dt.value == ''){		alert("�ް��Ⱓ�� �Է��Ͻʽÿ�.");	return;	}
		var st_dt = fm.st_dt.value;
		var end_dt = fm.end_dt.value;
		var user_id = fm.user_id.value;
		var title1 = fm.title1.value;
		var dept_id = dept_id;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=500,height=700,left=370,top=200');		
		fm.action = "user_search.jsp?st_dt="+st_dt+"&end_dt="+end_dt+"&dept_id="+dept_id+"&user_id="+user_id+"&title1="+title1;
		fm.target = "User_search";
		fm.submit();		
	}
 
 
</script>
 

</HEAD>
<BODY>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�λ���� > ���°��� > <span class=style5>�ް���û ���</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<form action="" name='form1' method='post'>
	<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
	<input type='hidden' name='go_url' value='<%=go_url%>'>
	<tr>
		<td align='right'>
		<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	 		<a href="javascript:free_reg()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
		<%}%>
			<a href="javascript:free_close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
		</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
		<td class='line'>			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'>�����</td>
                    <td align='left' >&nbsp; 
                      <select name="user_id">
                        <option value="">����</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); 
								if(ck_acar_id.equals(user.get("USER_ID"))){
									dept_id = String.valueOf(user.get("DEPT_ID"));
								}
								%>
								
                        <option value='<%=user.get("USER_ID")%>' <%if(ck_acar_id.equals(user.get("USER_ID")))%> selected <%%>><%=user.get("USER_NM")%></option>
						
                        <%	}
        				}		%>
                      </select><!-- &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��밡�� ������ :  <%=su%>�� -->
                    </td>
                    <td width="45%" align='left' >&nbsp;* ���ް� ��Ȳ &nbsp;&nbsp;&nbsp;&nbsp;���� :&nbsp;<%=b1_su%>&nbsp;&nbsp;&nbsp;&nbsp;����:&nbsp;<%=b2_su%> </td>
                    
				</tr>
                <tr> 
                    <td width='15%' class='title'>�ް�����</td>
                    <td width="40%" align='left' >&nbsp; 
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
	                      &nbsp;
						<select name='title1' size=1>
	 						<option value=''>�ߺз�����</option>
						</select>
					</td>
                    <td width="45%" align='left' >&nbsp;- �Ʒ��� ������ ����, �ڷγ���������� ������ ����
                   <br>&nbsp;- �����ް��� ���ټӻ�� �ش����� ��츸 ����
					<br>&nbsp;- �������� 09��~13�ñ���, ���Ĺ��� 13�ú���
					</td>
                </tr>
				<tr> 
                    <td class='title'>�ް��Ⱓ</td>
                    <td colspan="2">&nbsp; 
						<input type="text" name="st_dt" value='<%=st_dt%>' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
						�����ϼ���  
						<label><input type='radio' name="date_type1" value='1' onClick="javascript:date_type_input(1,1)"checked>����</label>
						<label><input type='radio' name="date_type1" value='2' onClick="javascript:date_type_input(1,2)">����</label>
						<label><input type='radio' name="date_type1" value='3' onClick="javascript:date_type_input(1,3)">��</label>
						<label><input type='radio' name="date_type1" value='4' onClick="javascript:date_type_input(1,4)">����</label>
						<label><input type='radio' name="date_type1" value='5' onClick="javascript:date_type_input(1,5)">�����Է�</label>
						<br/>
						&nbsp; 
						<input type="text" name="end_dt" value='' size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
						�����ϼ��� 
						<label><input type='radio' name="date_type2" value='1' onClick="javascript:date_type_input(2,1)"checked>����</label>
						<label><input type='radio' name="date_type2" value='2' onClick="javascript:date_type_input(2,2)">����</label>
						<label><input type='radio' name="date_type2" value='3' onClick="javascript:date_type_input(2,3)">��</label>
						<label><input type='radio' name="date_type2" value='4' onClick="javascript:date_type_input(2,4)">����</label>
						<label><input type='radio' name="date_type2" value='5' onClick="javascript:date_type_input(2,5)">�����Է�</label>
                    </td>
                </tr>				
				<tr> 
                    <td class='title'>��ü������</td>
                    <td colspan="2" align='left' >&nbsp; 
                      <input ytpe="text" name="user_nm" size="11" class=text readOnly>
					  <input type="hidden" name="work_id" >  <a href="javascript:User_search('<%=dept_id%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
        			  &nbsp; - ����,�ް�,����,�������϶� : ���ڹ��� ���� ��ü�� �˻�
                    </td>
                </tr>
                
                <tr> 
                    <td class='title'>÷��(����)</td>
                    <td colspan="2" >&nbsp; 
                      ÷�������� ������� �� ��ȭ�鿡�� ����Ͻñ� �ٶ��ϴ�.
                    </td>
                </tr>
                <tr> 
                    <td class='title'>����</td>
                    <td colspan="2" >&nbsp; 
                      <textarea name='content' rows='7' cols='70' ></textarea>
                    </td>
                </tr>
            </table>
			<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
			<input type="hidden" name="su" value="<%=su%>">		
			<input type="hidden" name="dept_id" value="<%=dept_id%>">
			<input type="hidden" name="cmd" value="">	
			<input type='hidden' name="s_width" value="<%=s_width%>">   
			<input type='hidden' name="s_height" value="<%=s_height%>">  
			<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>">  	
			
		</td>
	</tr>	
</form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize ></iframe>
</BODY>
</HTML>
