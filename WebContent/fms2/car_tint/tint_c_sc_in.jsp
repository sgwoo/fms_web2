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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	Vector vt = t_db.getCarTintCList(s_kd, t_wd, gubun1, gubun2, gubun3, st_dt, end_dt, sort);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	/* Title 고정 */
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
  <input type='hidden' name='from_page' value='tint_c_frame.jsp'>
  <input type='hidden' name='rent_mng_id' value=''>
  <input type='hidden' name='rent_l_cd' value=''>
  <input type='hidden' name='tint_no' value=''>  
  <input type='hidden' name='mode' value=''>    
<table border="0" cellspacing="0" cellpadding="0" width='1640'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
    <tr id='tr_title' style='position:relative;z-index:1'>
	<td class='line' width='320' id='td_title' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='60' class='title' style='height:51'>연번</td>    
		    <td width='130' class='title'>용품업체</td>						
        	    <td width='80' class='title'>요청등록일</td>
		    <td width="50" class='title'>의뢰자</td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1320'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td colspan="3" class='title' style='height:24'>기초사항</td>
		    <td colspan="9" class='title'>용품청구</td>				  
		    <td rowspan="2" width="300" class='title'>고객</td>
		</tr>
		<tr>
		    <td width='100' class='title' style='height:23'>차명</td>				  		    
		    <td width='140' class='title'>차대번호</td>
		    <td width='100' class='title'>색상</td>	
		    <td width='110' class='title'>마감요청일시</td>				  				  		    
		    <td width='80' class='title'>측후면썬팅</td>				      
		    <td width='80' class='title'>전면썬팅</td>				      
		    <td width='80' class='title'>블랙박스</td>					  
		    <td width='80' class='title'>내비게이션</td>		    
		    <td width='80' class='title'>기타용품</td>
		    <td width='90' class='title'>이동형충전기</td>								
		    <td width='80' class='title'>합계</td>							
		</tr>
	    </table>
	</td>
    </tr>
    <%	if(vt_size > 0){%>
    <tr>
	<td class='line' width='320' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
		%>
		<tr>
		    <td width='60' align='center'><%=i+1%><%if(String.valueOf(ht.get("USE_YN")).equals("N")){%>(해지)<%}%></td>		    
		    <td width='130' align='center'><span title='<%=ht.get("OFF_NM")%>'><%=ht.get("OFF_NM")%></span></td>
		    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REG_DT")))%></td>
		    <td width='50' align='center'><%if(String.valueOf(ht.get("DEPT_ID")).equals("1000")){%><font color=orange><%}%><%=ht.get("USER_NM")%><%if(String.valueOf(ht.get("DEPT_ID")).equals("1000")){%></font><%}%></td>					
		</tr>
		<%	}%>
				<tr>
				  <td class='title'>&nbsp;</td>				  
				  <td class='title'>&nbsp;</td>				  				  
				  <td class='title'>&nbsp;</td>				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  				  				  
				</tr>		
	    </table>
	</td>
	<td class='line' width='1320'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>			
		<tr>
		    <%if(String.valueOf(ht.get("RENT_L_CD")).equals("")){%>
		        <td colspan="3" align='center'>[대량용품]<span title='<%=ht.get("COM_MODEL_NM")%>'><%=Util.subData(String.valueOf(ht.get("COM_MODEL_NM")), 25)%></span></td>
		    <%}else{%>
		        <td width='100' align='center'><span title='<%=ht.get("CAR_NM2")%>'><%=Util.subData(String.valueOf(ht.get("CAR_NM2")), 6)%></span></td>
		        <td width='140' align='center'><%=ht.get("CAR_NUM2")%></td>
		        <td width='100' align='center'><span title='<%=ht.get("COLO")%>'><%=Util.subData(String.valueOf(ht.get("COLO")), 4)%></span></td>					
		    <%}%>
		    <td width='110' align='center'><a href="javascript:parent.tint_action('<%=ht.get("DOC_NO")%>', '<%=ht.get("TINT_NO")%>', '<%=ht.get("OFF_ID")%>');"><font color=red><%=AddUtil.ChangeDate3(String.valueOf(ht.get("SUP_EST_DT")))%></font></a></td>
		    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("S1_AMT")))%></td>
		    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("S2_AMT")))%></td>
		    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("B_AMT")))%></td>
		    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("N_AMT")))%></td>
		    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("E_AMT")))%></td>
		    <td width='90' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("EV_AMT")))%></td>					
		    <td width='80' align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>					
		    <td width='300' align='center'><%=ht.get("FIRM_NM")%><span title='<%=ht.get("FIRM_NM")%>'></span></td>					
		</tr>
		<%	
			total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("S1_AMT")));
			total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("S2_AMT")));
			total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("B_AMT")));
			total_amt4 	= total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("N_AMT")));
			total_amt5 	= total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("E_AMT")));
			total_amt6 	= total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("EV_AMT")));
			total_amt7 	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
		
			}%>
				<tr>
				  <td class='title'>&nbsp;</td>
				  <td class='title'>&nbsp;</td>				  				  
				  <td class='title'>&nbsp;</td>				  				  				  
				  <td class='title'>&nbsp;</td>				  				  				  				  
				  <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(total_amt1)%></td>	
				  <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(total_amt2)%></td>	
				  <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(total_amt3)%></td>	
				  <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(total_amt4)%></td>	
				  <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(total_amt5)%></td>	
				  <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(total_amt6)%></td>
				  <td class='title' style='text-align:right'><%=AddUtil.parseDecimal(total_amt7)%></td>				  				  
				  <td class='title'>&nbsp;</td>				  				  				  				  
				</tr>			
	    </table>
	</td>
    </tr>	
    <%	}else{%>                     
    <tr>
	<td class='line' width='260' id='td_con' style='position:relative;'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td align='center'>
		        <%if(t_wd.equals("")){%>검색어를 입력하십시오.
		        <%}else{%>등록된 데이타가 없습니다<%}%>
		    </td>
		</tr>
	    </table>
	</td>
	<td class='line' width='1120'>
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

