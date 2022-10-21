<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.cus_reg.*"%>
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
	
	int count =0;
	
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	
	Vector vt = cr_db.getServConfList("", s_kd, t_wd, gubun1, gubun2, gubun3, gubun4, gubun5, st_dt, end_dt, sort);
	int vt_size = vt.size();
	
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
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
	
	/*
	var checkflag = "false";
	function AllSelect(field){
		if(checkflag == "false"){
			for(i=0; i<field.length; i++){
				field[i].checked = true;
			}
			checkflag = "true";
			return;
		}else{
			for(i=0; i<field.length; i++){
				field[i].checked = false;
			}
			checkflag = "false";
			return;
		}
	} */
	
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
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    
  <input type='hidden' name='jung_dt' value=''>  
  <table border="0" cellspacing="0" cellpadding="0" width='1760'>
    <tr>
      <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
	  <td class='line' width='370' id='td_title' style='position:relative;'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
		    <td width='40' class='title' style='height:45'>����</td>
			<td width='40' class='title'>&nbsp;<br><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"><br>&nbsp;</td>
			<td width='150' class='title'>�����ü</td>	
        	<td width='80' class='title'>��������</td>
		    <td width="60" class='title'>�����</td>					
		  </tr>
		</table>
	  </td>
	  <td class='line' width='1390'>
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
		<!--	<td colspan="4" class='title'>��������</td>			-->		  
			<td colspan="3" class='title' style='height:23'>���ʻ���</td>
			<td colspan="7" class='title'>�������</td>
			<td rowspan="2" width="150" class='title'>��</td>
			<td colspan="3" class='title'>������</td>
		  </tr>
		  <tr>
		<!--	<td width='60' class='title'>û����</td>
			<td width='60' class='title'>Ȯ����</td>
			<td width='60' class='title'>������</td>									
			<td width='60' class='title'>����</td>		 -->												  
			<td width='90' class='title'>������ȣ</td>
			<td width='100' class='title'>����</td>	
			<td width='80' class='title'>��������</td>			  			
			<td width='80' class='title'>������Ÿ�</td>	
			<td width='70' class='title'>����з�</td>	
			<td width='90' class='title'>����</td>					  
			<td width='90' class='title'>��ǰ</td>	
			<td width='90' class='title'>���ް�</td>	
			<td width='90' class='title'>�ΰ���</td>					  				  
			<td width='100' class='title'>����ݾ�</td>			
			<td width='120' class='title'>����</td>					  
			<td width='120' class='title'>���</td>					  
			<td width='120' class='title'>ī��</td>					  
		  </tr>
		</table>
	  </td>
	</tr>
<%
	if(vt_size > 0)
	{
%>
	<tr>
		<td class='line' width='370' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td  width='40' align='center'><%=i+1%></td>
					
					<td  width='40' align='center'>	<!-- set_dt �Ǵ� jung_st�� Ȯ�� -->				
						 <input type="checkbox" name="ch_cd" value="<%=ht.get("CAR_MNG_ID")%>/<%=ht.get("SERV_ID")%>"  <% if (!String.valueOf(ht.get("JUNG_ST")).equals("") )  {%> disabled <% } %> >
					</td>
										
					<td  width='150' align='center'><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 11)%></span></td>										
					<td  width='80' align='center'><a href="javascript:parent.serv_action('<%=ht.get("CAR_MNG_ID")%>', '<%=ht.get("SERV_ID")%>', '<%=ht.get("ACCID_ID")%>');"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("SERV_DT")))%></a></td>
					<td  width='60' align='center'><%=ht.get("USER_NM")%></td>					
				</tr>
<%
		}
%>
				<tr>
				  <td class='title'>&nbsp;</td>				  
				  <td class='title'>&nbsp;</td>				  				  
				  <td class='title'>&nbsp;</td>				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  				  
				  <td class='title'>&nbsp;</td>				  				  
				</tr>
			</table>
		</td>
		<td class='line' width='1390'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>			
				<tr>
				<!--	<td  width='60' align='center'><%=ht.get("USER_NM1")%></td>
					<td  width='60' align='center'><%=ht.get("USER_NM2")%></td>										
					<td  width='60' align='center'><%=ht.get("USER_NM3")%></td>										
					<td  width='60' align='center'><%=ht.get("USER_NM4")%></td>			 -->																					
					<td  width='90' align='center'><%=ht.get("CAR_NO")%></td>
					<td  width='100' align='center'><span title='<%=ht.get("CAR_NM")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM")), 8)%></span></td>					
					<td  width='80' align='center'><%=ht.get("RENT_WAY")%></td>	
					<td  width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_DIST")))%></td>					
					<td  width='70' align='center'><%=ht.get("SERV_ST_NM")%></td>					
					<td  width='90' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("R_LABOR")))%></td>							
					<td  width='90' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("R_AMT")))%></td>
					<td  width='90' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("SUP_AMT")))%></td>
					<td  width='90' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("ADD_AMT")))%></td>
					<td  width='100' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("REP_AMT")))%></td>
					<td  width='150' align='center'><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 9)%></span></td>					
					<td  width='120' align='center'><%=ht.get("PAY_ST4")%> <%=ht.get("PAY_DT4")%></td>																				
					<td  width='120' align='center'><%=ht.get("PAY_ST1")%><%=ht.get("PAY_ST2")%> <%=ht.get("PAY_DT1")%><%=ht.get("PAY_DT2")%></td>					
					<td  width='120' align='center'><%=ht.get("PAY_ST3")%> <%=ht.get("PAY_DT3")%></td>
				</tr>
<%
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("R_LABOR")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("R_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("SUP_AMT")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("ADD_AMT")));
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("REP_AMT")));
		}
%>
				<tr>
			<!--	  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>				  				  
				  <td class='title'>&nbsp;</td>				  				  				  
				  <td class='title'>&nbsp;</td>		-->		  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  
				  <td class='title'>&nbsp;</td>		
				  <td class='title'>&nbsp;</td>				  				  				  				  
				  <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt1)%></td>	
				  <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt2)%></td>	
				  <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt3)%></td>	
				  <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt4)%></td>	
				  <td class='title' style='text-align:right'><%=Util.parseDecimal(total_amt5)%></td>	
				  <td class='title'>&nbsp;</td>				  				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  				  				  
				</tr>
			</table>
		</td>
<%	}                  
	else               
	{
%>                     
	<tr>
		<td class='line' width='370' id='td_con' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td align='center'>
					<%if(t_wd.equals("")){%>�˻�� �Է��Ͻʽÿ�.
					<%}else{%>��ϵ� ����Ÿ�� �����ϴ�<%}%></td>
				</tr>
			</table>
		</td>
		<td class='line' width='1390'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%                     
	}                  
%>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

