<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,  acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "17", "07", "04");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 1; //sc ��¶��μ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-100;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+
					"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
				   	"&sh_height="+height+"";
					
	
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//function view_cons_cost(car_comp_id, car_cd, off_id, cost_b_dt){
	//	window.open("cost_cost_u.jsp?auth_rw=<%=auth_rw%>&car_comp_id="+car_comp_id+"&car_cd="+car_cd+"&off_id="+off_id+"&cost_b_dt="+cost_b_dt, "VIEW_COSTO", "left=20, top=20, width=800, height=750");
	//}

function ConsCostYn(){
	
	var fm = inner.document.form1;	
	fm.use_yn.value = document.form1.use_yn.value;
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
	 	alert("��뿩�� ������ ����� �����ϼ���.");
		return;
	}	
	
	if(confirm('ó���Ͻðڽ��ϱ�?')){		
		//fm.target = "i_no";
		fm.target = "_blank";
		fm.action = "cons_cost_yn_a.jsp";
		fm.submit();	
	}
}	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<%@ include file="/acar/getNaviCookies.jsp" %>
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
  <input type='hidden' name='from_page' value='/fms2/cons_cost/cons_cost_frame.jsp'>
  <input type='hidden' name='cons_no' value=''>
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='doc_bit' value='5'>      
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	  <td><img src="/acar/images/center/icon_arrow.gif" align=absmiddle> <span class=style2>�� <input type='text' name='size' value='' size='4' class=whitenum> ��</span>
	  		&nbsp;
	  		<select name='use_yn'>
              <option value='N'>�̻��</option>
              <option value='Y'>���</option>
            </select>
            <a href="javascript:ConsCostYn()" onMouseOver="window.status=''; return true" title='��뿩��ó��'><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>&nbsp;
	  </td>
	</tr>  
	<tr>
		<td>
			<table border="0" cellspacing="0" cellpadding="0" width=100%>
				<tr>
					<td>
						<iframe src="cons_cost_sc_in.jsp<%=valus%>" name="inner" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
						</iframe>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
