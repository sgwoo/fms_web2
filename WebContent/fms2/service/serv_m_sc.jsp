<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 1; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-110;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	LoginBean login = LoginBean.getInstance();
	
	if(nm_db.getWorkAuthUser("�Ƹ���ī�̿�",user_id)){
		s_kd = "8";
	}
	
	String dept_id = login.getDept_id(ck_acar_id);
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
			
//��ǰ����
function serv_action(car_mng_id, serv_id, accid_id){
	var fm = document.form1;
<%		if(!dept_id.equals("8888")){%>	
	var SUBWIN="/acar/cus_reg/serv_reg.jsp?car_mng_id=" + car_mng_id + "&serv_id=" + serv_id+"&accid_id="+accid_id+"&from_page=/fms2/service/serv_m_frame.jsp"; 
<%		}else{%>	
	var SUBWIN="/acar/cus_reg/serv_accid_reg.jsp?car_mng_id=" + car_mng_id + "&serv_id=" + serv_id+"&accid_id="+accid_id; 
<%		}%>	
	window.open(SUBWIN, 'popwin_serv_reg','scrollbars=yes,status=no,resizable=no,width=850,height=720,top=50,left=50');
}
					
	
function print_open(){	
	  var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;					
				}
			}
		}	
		if(cnt == 0){
		 	alert("�μ��� ���� �����ϼ���.");
			return;
		}
		
		var newWin = window.open("", "pop", "left=50, top=50, width=1100, height=768, resizable=yes, scrollbars=yes, status=yes");
		
		fm.target = "pop";
		fm.action = "serv_m_sc_in_prn.jsp";
		fm.submit();		
					
	//	fm.action = 'serv_m_sc_in_prn.jsp';
	//	fm.target = '_blank';
	//	fm.submit();	
}
	

//�������� ���� ����
function reg_del(){	
	   var fm = inner.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_cd"){		
				if(ck.checked == true){
					idnum=ck.value;
					cnt++;					
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("����ó���� ���� �����ϼ���.");
			return;
		}
		
		//�����ڵ���, ���������ڵ���, �ٷ������� ������� ���� ���� ���� ó�� - �ϴ� �������� 
		if( document.form1.s_kd.value == '11' ||  document.form1.s_kd.value == '14' ||  document.form1.s_kd.value == '15' ){
		} else {
		 	alert("�ش� �ŷ�ó�� ������ �� �����ϴ�.!!!");
			return;
		}
		
		if(confirm('����ó���Ͻðڽ��ϱ�?')){		
			fm.target = "d_content";
			fm.action = "serv_doc_set_a.jsp?cmd=d" ;	
			fm.submit();	
		}		
		
}	

//���繮�����
function select_jung(){
	var fm = inner.document.form1;	
	var len=fm.elements.length;
	var cnt=0;
	var idnum="";
	for(var i=0 ; i<len ; i++){
		var ck=fm.elements[i];		
		if(ck.name == "ch_cd"){		
			if(ck.checked == true){
				cnt++;
				idnum=ck.value;
			}
		}
	}
	
	if(cnt == 0){
	 	alert("���繮������� ���� �����ϼ���.");
		return;
	}	
	
	//s_kd: 7, 8, 9, 10, 11 , 14,15�� ���ؼ� ó����.
	if ( document.form1.s_kd.value == '7' || document.form1.s_kd.value == '8' || document.form1.s_kd.value == '9' || document.form1.s_kd.value == '10' || document.form1.s_kd.value == '11' || document.form1.s_kd.value == '14' || document.form1.s_kd.value === '15' ) {
	} else {
		alert('�ֿ� �ŷ�ó�� �ƴմϴ�.!!'); 
		return;
	}
	
	
	var newWin = window.open("", "pop", "left=50, top=50, width=1100, height=768, resizable=yes, scrollbars=yes, status=yes");
	
	fm.target = "pop";
	fm.action = "serv_req_multi_i.jsp";
	fm.submit();		
		
}		

function ChangeDT(arg)
{
	var theForm = document.form1;
	theForm.jung_dt.value = ChangeDate(theForm.jung_dt.value);	
}	

//-->
</script>

</head>
<body leftmargin="15">
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
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>       
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 		value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/fms2/service/serv_m_frame.jsp'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  <tr>
	  <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span>
	   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  <%if(nm_db.getWorkAuthUser("������",user_id) || nm_db.getWorkAuthUser("������������ⳳ",user_id) || nm_db.getWorkAuthUser("Ź�۰�����",user_id) || nm_db.getWorkAuthUser("���·������",user_id)  ){%> 	 
	  	 <a href="javascript:select_jung();">[���繮�����]</a>&nbsp;&nbsp; 	
	  <%}%>	
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="javascript:print_open()"> [�μ�ȭ�麸��]</a>&nbsp;&nbsp;&nbsp;	
	  	<%if(nm_db.getWorkAuthUser("������",user_id) ) {%>     
	<!-- <span class=style2>��������</span>&nbsp;<input type='text' name="set_dt"  size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); '> &nbsp;&nbsp;&nbsp; -->
 
	 <a href="javascript:reg_del()"> [����]</a>&nbsp; <!-- //�ϰ���ϰ� ������ (�����ڵ���, ���������ڵ���, �ٷ������� - ���� �ߺ���� ���� ���� -->
	
	<%} %> 
	
	  </td>
	</tr>
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="serv_m_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>	
    <tr>
	    <td>�� ��뷮�ŷ�ó�� ���񳻿� Ȯ���� ���繮�� ����� �����մϴ�. </td>
	</tr>	
</table>

</form>
</body>
</html>
