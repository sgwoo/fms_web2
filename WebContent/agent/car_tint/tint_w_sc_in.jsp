<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
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
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	Vector vt = t_db.getCarTintWList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//��ü����
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_cd"){		
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}	
		}
		return;
	}		
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'> 
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>       
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name='sort' 	value='<%=sort%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>
  <input type='hidden' name='from_page' value='/agent/car_tint/tint_w_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width='1730'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='290' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='60' class='title' >����</td>
		    <td width='30' class='title'>&nbsp;<br><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"><br>&nbsp;</td>
		    <td width='70' class='title'>��ǰ��ü</td>						
        	    <td width='80' class='title'>��û�����</td>
		    <td width="50" class='title'>�Ƿ���</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1440'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td colspan="4" class='title' style='height:24'>���ʻ���</td>
		    <td colspan="7" class='title'>��ǰ��û</td>				  
		    <td rowspan="2" width="100" class='title'>��</td>
		    <td rowspan="2" width="110" class='title'>�������</td>
		    <td rowspan="2" width="110" class='title'>��Ͽ�����</td>
		    <td rowspan="2" width="80" class='title'>���ʵ����</td>				  
		</tr>
		<tr>
		    <td width='100' class='title' style='height:23'>����</td>				  
		    <td width='120' class='title'>�����ȣ</td>
		    <td width='140' class='title'>�����ȣ</td>
		    <td width='100' class='title'>����</td>	
		    <td width='110' class='title'>������û�Ͻ�</td>				  				  
		    <td width='100' class='title'>������</td>	
		    <td width='80' class='title'>���ĸ����</td>				      
		    <td width='80' class='title'>�������</td>				      
		    <td width='70' class='title'>���ڽ�</td>					  
		    <td width='70' class='title'>������̼�</td>		    
		    <td width='70' class='title'>��Ÿ��ǰ</td>							
		</tr>
	    </table>
	</td>
    </tr>
    <%	if(vt_size > 0){%>
    <tr>
	<td class='line' width='290' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
		<tr>
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='60' align='center'><%=i+1%><%if(String.valueOf(ht.get("USE_YN")).equals("N")){%>(����)<%}%></td>
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='30' align='center'><input type="checkbox" name="ch_cd" value="<%=ht.get("TINT_NO")%>"></td>
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='70' align='center'><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 4)%></span></td>
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='50' align='center'><%if(String.valueOf(ht.get("DEPT_ID")).equals("1000")){%><font color=orange><%}%><%=ht.get("USER_NM")%><%if(String.valueOf(ht.get("DEPT_ID")).equals("1000")){%></font><%}%></td>					
		</tr>
		<%	}%>
	    </table>
	</td>
	<td class='line' width='1440'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>			
		<tr>
		    <%if(String.valueOf(ht.get("RENT_L_CD")).equals("")){%>
		        <td colspan="4" align='center'>[�뷮��ǰ]<span title='<%=ht.get("COM_MODEL_NM")%>'><%=Util.subData(String.valueOf(ht.get("COM_MODEL_NM")), 25)%></span></td>
		    <%}else{%>
		        <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='100' align='center'><span title='<%=ht.get("CAR_NM2")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM2")), 6)%></span></td>
		        <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='120' align='center'><%=ht.get("RPT_NO")%></td>
		        <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='140' align='center'><%=ht.get("CAR_NUM2")%></td>
		        <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='100' align='center'><span title='<%=ht.get("COLO")%>'><%=Util.subData(String.valueOf(ht.get("COLO")), 4)%></span></td>					
		    <%}%>
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='110' align='center'><a href="javascript:parent.tint_action('<%=ht.get("TINT_NO")%>', '<%=ht.get("OFF_ID")%>');"><font color=red><%=AddUtil.ChangeDate3(String.valueOf(ht.get("SUP_EST_DT")))%></font></a></td>
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='100' align='center'><%=ht.get("COM_TINT_NM")%> <%=ht.get("COM_FILM_ST_NM")%></td>							
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='80' align='center'><%if(String.valueOf(ht.get("S1_YN")).equals("Y")){%>�ð�<%}%></td>
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='80' align='center'><%if(String.valueOf(ht.get("S2_YN")).equals("Y")){%>�ð�<%}%></td>
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='70' align='center'><%if(String.valueOf(ht.get("B_YN")).equals("Y")){%>��ġ<%}%></td>
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='70' align='center'><%if(String.valueOf(ht.get("N_YN")).equals("Y")){%>��ġ<%}%></td>
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='70' align='center'><%if(String.valueOf(ht.get("E_YN")).equals("Y")){%>����<%}%></td>					
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='100' align='center'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 6)%><span title='<%=ht.get("FIRM_NM")%>'></span></td>					
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='110' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("DLV_EST_DT")))%></td>					
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='110' align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("REG_EST_DT")))%></td>
		    <td <%if(!String.valueOf(ht.get("INIT_REG_DT")).equals("")){%>class='is'<%}%> width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%></td>					
		</tr>
		<%	}%>
	    </table>
	</td>
    </tr>	
    <%	}else{%>                     
    <tr>
	<td class='line' width='290' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
		        <%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.
		        <%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%>
		    </td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1440'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td>&nbsp;</td>
		</tr>
	    </table>
	</td>
    </tr>
    <%	}%>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

