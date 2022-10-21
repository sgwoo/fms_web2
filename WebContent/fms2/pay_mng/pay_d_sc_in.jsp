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
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	
	Vector vt =  pm_db.getPayDList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4);
	int vt_size = vt.size();
	
	long total_amt[] = new long[8];
	
	
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
	
	//전체선택
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
  <input type='hidden' name='from_page' value='/fms2/pay_mng/pay_d_frame.jsp'>  
<table border="0" cellspacing="0" cellpadding="0" width='1550'>
  <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
    <td class='line' width='420' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>		
          <td width='30' class='title' style='height:51'>연번</td>	  
          <td width='40' class='title'>출금<br>시간</td>
          <td width='80' class='title'>청구일자</td>
          <td width='150' class='title'>출금항목</td>		  
          <td width="40" class='title'>건수</td>				  
          <td width="50" class='title'>등록자</td>				  		  
        </tr>
      </table>
	</td>
	<td class='line' width='1130'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
          <td colspan="4" class='title'>결재</td>
		  <td colspan="7" class='title'>출금금액</td>
          <td width='160' rowspan="2" class='title'>기간</td>
		  </tr>
		<tr>
		  <td width='70' class='title'>문서번호</td>		
		  <td width='60' class='title'>기안자</td>
		  <td width='70' class='title'>지점장</td>		  
		  <td width='70' class='title'>총무팀장</td>
		  <td width="100" class='title'>합계</td>
		  <td width="100" class='title'>현금지출</td>
		  <td width="100" class='title'>계좌이체</td>		  
		  <td width="100" class='title'>자동이체</td>
		  <td width="100" class='title'>선불카드</td>
		  <td width="100" class='title'>후불카드</td>
		  <td width="100" class='title'>카드할부</td>
		</tr>
	  </table>
	</td>
  </tr>
  <%if(vt_size > 0){%>
  <tr>		
    <td class='line' width='420' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        <tr> 
          <td width='30' align='center'><%if(String.valueOf(ht.get("DOC_CODE")).equals("")){%><input type="checkbox" name="ch_cd" value="<%=ht.get("P_REQ_DT")%><%=ht.get("P_GUBUN")%><%=ht.get("REG_ID")%><%=ht.get("ACCT_CODE")%><%=ht.get("AT_ONCE")%><%=i%>"><%}else{%>-<%}%></td>		
          <td width='30' align='center'><%=i+1%></td>		
          <td width='40' align='center'>
		  <%if(String.valueOf(ht.get("AT_ONCE")).equals("Y")){%>
		  <font color=red>즉시</font>
		  <%}else{%>
		  지정
		  <%}%>
		  </td>					    
          <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_REQ_DT")))%></td>         
  		  <td width='150' align='center'><%=ht.get("GUBUN_NM")%></td>
          <td width='40' align='center'><%=ht.get("TOT_CNT")%></td>
  		  <td width='50' align='center'><%=ht.get("REG_NM")%></td>		  
		  <input type='hidden' name='gubun_nm' value='<%=ht.get("GUBUN_NM")%>'> 
		  <input type='hidden' name='tot_cnt' value='<%=ht.get("TOT_CNT")%>'> 
		  <input type='hidden' name='tot_amt' value='<%=ht.get("TOT_AMT")%>'> 
		  <input type='hidden' name='amt1' value='<%=ht.get("AMT1")%>'> 
		  <input type='hidden' name='amt2' value='<%=ht.get("AMT5")%>'> 		  		  
		  <input type='hidden' name='amt3' value='<%=ht.get("AMT4")%>'> 		  
		  <input type='hidden' name='amt4' value='<%=ht.get("AMT2")%>'> 
		  <input type='hidden' name='amt5' value='<%=ht.get("AMT3")%>'> 
		  <input type='hidden' name='amt7' value='<%=ht.get("AMT7")%>'>
        </tr>      
        <%	}%>
				<tr>
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
	<td class='line' width='1130'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				//은행코드 가져오기
				if(String.valueOf(ht.get("BANK_ID")).equals("")){
					
				}
				total_amt[6] 		+= AddUtil.parseLong(String.valueOf(ht.get("TOT_CNT")));
				total_amt[0] 		+= AddUtil.parseLong(String.valueOf(ht.get("TOT_AMT")));
				total_amt[1] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
				total_amt[2] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
				total_amt[3] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
				total_amt[4] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
				total_amt[5] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
				total_amt[7] 		+= AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
				%>
		<tr>
		  <td width='70' align='center'><%=ht.get("DOC_NO2")%></td>		
		  <td width='60' align='center'>
		    <%if(String.valueOf(ht.get("USER_DT1")).equals("")){%>
			  -
			<%}else{%>
			  <a href="javascript:parent.pay_doc_action('<%=ht.get("DOC_CODE")%>', '<%=ht.get("P_EST_DT")%>', '<%=ht.get("P_GUBUN")%>', '<%=ht.get("BR_ID")%>', '1', '<%=ht.get("DOC_NO")%>','<%=ht.get("P_REQ_DT")%>', '<%=ht.get("P_EST_DT2")%>');" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM1")%></a>
			<%}%>		  
		  </td>
		  <td width='70' align='center'>
		    <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && !String.valueOf(ht.get("BR_ID2")).equals("S1") && !String.valueOf(ht.get("BR_ID2")).equals("S2") && !String.valueOf(ht.get("BR_ID2")).equals("I1") && !String.valueOf(ht.get("BR_ID2")).equals("K3") && !String.valueOf(ht.get("BR_ID2")).equals("S3") && !String.valueOf(ht.get("BR_ID2")).equals("S4") && !String.valueOf(ht.get("BR_ID2")).equals("S5") && !String.valueOf(ht.get("BR_ID2")).equals("S6") && !String.valueOf(ht.get("USER_ID2")).equals("XXXXXX") && !String.valueOf(ht.get("USER_ID2")).equals("")){%>
		    <%		if(String.valueOf(ht.get("USER_DT2")).equals("")){%>
			  <a href="javascript:parent.pay_doc_action('<%=ht.get("DOC_CODE")%>', '<%=ht.get("P_EST_DT")%>', '<%=ht.get("P_GUBUN")%>', '<%=ht.get("BR_ID")%>', '2', '<%=ht.get("DOC_NO")%>','<%=ht.get("P_REQ_DT")%>', '<%=ht.get("P_EST_DT2")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
			<%		}else{%>  
			  <a href="javascript:parent.pay_doc_action('<%=ht.get("DOC_CODE")%>', '<%=ht.get("P_EST_DT")%>', '<%=ht.get("P_GUBUN")%>', '<%=ht.get("BR_ID")%>', '2', '<%=ht.get("DOC_NO")%>','<%=ht.get("P_REQ_DT")%>', '<%=ht.get("P_EST_DT2")%>');" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM2")%></a>
			<%		}%>	
			<%}else{%>
			<%		if(!String.valueOf(ht.get("BR_ID")).equals("S1") && !String.valueOf(ht.get("BR_ID")).equals("S2") && !String.valueOf(ht.get("BR_ID")).equals("I1") && !String.valueOf(ht.get("BR_ID")).equals("K3") && !String.valueOf(ht.get("BR_ID")).equals("S3") && !String.valueOf(ht.get("BR_ID")).equals("S4") && !String.valueOf(ht.get("BR_ID")).equals("S5") && !String.valueOf(ht.get("BR_ID")).equals("S6") && String.valueOf(ht.get("USER_ID2")).equals("XXXXXX")){%>
			부재중결재
			<%		}else{%>
			  -
			<%		}%>  
			<%}%>		  				  
		  </td>
		  <td width='70' align='center'>
		    <%if(!String.valueOf(ht.get("USER_DT1")).equals("") && !String.valueOf(ht.get("USER_ID3")).equals("XXXXXX") && !String.valueOf(ht.get("USER_ID3")).equals("")){%>
		    <%		if(String.valueOf(ht.get("USER_DT3")).equals("")){%>
			  <a href="javascript:parent.pay_doc_action('<%=ht.get("DOC_CODE")%>', '<%=ht.get("P_EST_DT")%>', '<%=ht.get("P_GUBUN")%>', '<%=ht.get("BR_ID")%>', '2', '<%=ht.get("DOC_NO")%>','<%=ht.get("P_REQ_DT")%>', '<%=ht.get("P_EST_DT2")%>');" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/acar/images/center/button_in_gj.gif" align="absmiddle" border="0"></a>
			<%		}else{%>  
			  <a href="javascript:parent.pay_doc_action('<%=ht.get("DOC_CODE")%>', '<%=ht.get("P_EST_DT")%>', '<%=ht.get("P_GUBUN")%>', '<%=ht.get("BR_ID")%>', '2', '<%=ht.get("DOC_NO")%>','<%=ht.get("P_REQ_DT")%>', '<%=ht.get("P_EST_DT2")%>');" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM3")%></a>
			<%		}%>	
			<%}else{%>
			  -
			<%}%>		  				  
		  </td>
		  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("TOT_AMT")))%></td>
		  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></td>
		  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT5")))%></td>		  
		  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></td>
		  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></td>
		  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></td>
		  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT7")))%></td>
		  <td width='160' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MIN_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("MAX_DT")))%></td>
		</tr>	
<%		}	%>
				<tr>
				  <td class='title' colspan="4">합계</td>
				  <td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt[0])%></td>
				  <td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt[1])%></td>
				  <td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt[2])%></td>
				  <td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt[3])%></td>
				  <td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt[4])%></td>				  				  				  				  
				  <td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt[5])%></td>				  				  				  				  				  
				  <td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt[7])%></td>
				  <td class='title'>&nbsp;</td>				  
				</tr>		
				
	  </table>
	</td>
<%	}else{%>                     
    <tr>
	    <td class='line' width='420' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
                </table>
	    </td>
	    <td class='line' width='1130'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
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

