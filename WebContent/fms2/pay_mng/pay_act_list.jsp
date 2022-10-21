<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	String bank_code 	= request.getParameter("bank_code")==null? "":request.getParameter("bank_code");
	String p_pay_dt 	= request.getParameter("p_pay_dt")==null? "":request.getParameter("p_pay_dt");
	String off_nm	 	= request.getParameter("off_nm")==null? "":request.getParameter("off_nm");
	String bank_no	 	= request.getParameter("bank_no")==null? "":request.getParameter("bank_no");
	String a_bank_no 	= request.getParameter("a_bank_no")==null? "":request.getParameter("a_bank_no");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	
	Vector vt =  pm_db.getPayActList(bank_code, p_pay_dt, off_nm, bank_no, a_bank_no);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}
	
	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='req_dt'    value=''>      
  <input type='hidden' name='from_page' value='/fms2/pay_mng/pay_act_list.jsp'>  
<table border="0" cellspacing="0" cellpadding="0" width='1970'>
  <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
    <td class='line' width='310' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='310'>
        <tr> 
          <td width='30' class='title' style='height:51'>연번</td>   
          <td width='60' class='title'>상태</td>		  
		  <td width='60' class='title'>증빙서류</td>		  
          <td width='60' class='title'>등록방식</td>
          <td width='100' class='title'>출금항목</td>		  
        </tr>
      </table>
	</td>
	<td class='line' width='1660'>
	  <table border="0" cellspacing="1" cellpadding="0" width='1660'>
		<tr>
		  <td width="70" rowspan="2" class='title'>계정과목</td>		
		  <td width="70" rowspan="2" class='title'>전표<br>계정과목</td>				  				
		  <td width="100" rowspan="2" class='title'>지출처</td>
		  <td width="200" rowspan="2" class='title'>적요</td>
          <td width='60' rowspan="2" class='title'>출금방식</td>		
          <td width="100" rowspan="2" class='title'>금액</td>
		  <td colspan="3" class='title'>네오엠</td>		  
          <td colspan="2" class='title'>입금정보</td>
		  <td colspan="2" class='title'>출금정보</td>
          <td width="80" rowspan="2" class='title'>출금일자</td>
          <td width="80" rowspan="2" class='title'>예정일자</td>
          <td width="80" rowspan="2" class='title'>등록일자</td>		  		  
		  <td width="60" rowspan="2" class='title'>등록자</td>		  		  
		  <td colspan="2" class='title'>문서</td>
		</tr>
		<tr>
		  <td width="100" class='title'>거래처</td>
		  <td width="80" class='title'>전표일자</td>
		  <td width="60" class='title'>전표번호</td>
		  <td width='80' class='title'>금융사</td>
		  <td width='120' class='title'>계좌번호</td>
		  <td width='80' class='title'>금융사</td>
		  <td width='120' class='title'>계좌번호</td>
		  <td width="60" class='title'>기안자</td>
		  <td width="60" class='title'>팀장</td>
		</tr>
	  </table>
	</td>
  </tr>
  <%if(vt_size > 0){%>
  <tr>		
    <td class='line' width='310' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='310'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        <tr> 
          <td width='30' align='center'><%=i+1%></td>		  
		  <td width='60' align='center'><%=ht.get("STEP_NM")%></td>		  
          <td width='60' align='center'>-</td>
          <td width='60' align='center'><%=ht.get("REG_ST_NM")%></td>         		  		  
  		  <td width='100' align='center'><%=ht.get("GUBUN_NM")%>
		  </td>
        </tr>      
        <%	}%>
				<tr>						
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				</tr>		
      </table>
	</td>
	<td class='line' width='1660'>
	  <table border="0" cellspacing="1" cellpadding="0" width='1660'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				//은행코드 가져오기
				if(String.valueOf(ht.get("BANK_ID")).equals("")){
					
				}
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));%>
		<tr>
          <td width='70' align='center'><%=ht.get("ACCT_CODE")%></td>         		
          <td width='70' align='center'><%=ht.get("R_ACCT_CODE")%></td>         				  				
		  <td width='100' align='center'><span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 6)%></span></td>
		  <td width='200' align='center'><span title='<%=ht.get("P_CONT")%>'><%=Util.subData(String.valueOf(ht.get("P_CONT")), 15)%></span></td>
          <td width='60' align='center'><%=ht.get("WAY_NM")%></td>         		
		  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
		  <td width='100' align='center'><span title='<%=ht.get("VEN_NAME")%>'><%=Util.subData(String.valueOf(ht.get("VEN_NAME")), 6)%></span></td>		  		  		
		  <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("AUTODOCU_WRITE_DATE")))%></td>		  
		  <td width='60' align='center'><%=ht.get("AUTODOCU_DATA_NO")%></td>		  		  
		  <td width='80' align='center'><span title='<%=ht.get("BANK_NM")%>'><%=Util.subData(String.valueOf(ht.get("BANK_NM")), 6)%></span></td>
		  <td width='120' align='center'><%=ht.get("BANK_NO")%></td>
		  <td width='80' align='center'><span title='<%=ht.get("A_BANK_NM")%>'><%=Util.subData(String.valueOf(ht.get("A_BANK_NM")), 6)%></span></td>
		  <td width='120' align='center'><%=ht.get("A_BANK_NO")%></td>
          <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_PAY_DT")))%></td>		  
          <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_EST_DT")))%></td>		  
          <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_REG_DT")))%></td>		  		  		  
		  <td width='60' align='center'><%=ht.get("REG_NM")%></td>		  		  
		  <td width='60' align='center'><%=ht.get("USER_NM1")%></td>
		  <td width='60' align='center'><%=ht.get("USER_NM2")%></td>
		</tr>	
<%		}	%>
				<tr>		
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>합계</td>					
				    <td class='title'>&nbsp;</td>
					<td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt1)%></td>					
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>					
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				</tr>
	  </table>
	</td>

<%	}	%>
</table>
</form>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=vt_size%>';
//-->
</script>
</body>
</html>

