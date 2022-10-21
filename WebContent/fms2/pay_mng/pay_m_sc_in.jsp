<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*"%>
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
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int count =0;
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector vt =  pm_db.getPayMList(s_kd, t_wd, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2	= 0;
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
  <input type='hidden' name='from_page' value='/fms2/pay_mng/pay_m_frame.jsp'>  
<table border="0" cellspacing="0" cellpadding="0" width='1360'>
  <tr id='tr_title' style='position:relative;z-index:1'>
  	<tr><td class=line2 colspan="2"></td></tr>		
    <td class='line' width='570' id='td_title' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr> 
          <td width='30' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
          <td width='50' class='title' style='height:51'>연번</td>    
          <td width='80' class='title'>상태</td>		  
		      <td width='50' class='title'>증빙<br>서류</td>
          <td width='200' class='title'>출금항목</td>		  
          <td width="80" class='title'>출금일자</td>
          <td width="80" class='title'>거래일자</td>		  
        </tr>
      </table>
	</td>
	<td class='line' width='790'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		  <td width="200" rowspan="2" class='title'>지출처</td>		  
          <td width='80' rowspan="2" class='title'>출금방식</td>		
          <td width="110" rowspan="2" class='title'>금액</td>
		  <td colspan="3" class='title'>문서결재</td>
		  <td colspan="2" class='title'>송금결재</td>		  
		</tr>
		<tr>
		  <td width="80" class='title'>기안자</td>
		  <td width="80" class='title'>지점장</td>
		  <td width="80" class='title'>총무팀장</td>		  
		  <td width="80" class='title'>요청자</td>
		  <td width="80" class='title'>팀장</td>
		</tr>
	  </table>
	</td>
  </tr>
  <%if(vt_size > 0){%>
  <tr>		
    <td class='line' width='570' id='td_con' style='position:relative;'> 
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);%>
        <tr> 
          <td width='30' align='center'>
		  <input type="checkbox" name="ch_cd" value="<%=ht.get("REQSEQ")%>">
		  </td>
          <td width='50' align='center'><%=i+1%></td>		  
		  <td width='80' align='center'>
		  <%if(String.valueOf(ht.get("AT_ONCE")).equals("Y") && !String.valueOf(ht.get("STEP_NM")).equals("송금완료") && !String.valueOf(ht.get("STEP_NM")).equals("회계처리")){%>
		  <font color=red><%=ht.get("STEP_NM")%></font>
		  <%}else{%>
		  <%=ht.get("STEP_NM")%>
		  <%}%>
		  </td>		  
          <td width='50' align='center'>
		  <%if(String.valueOf(ht.get("P_GUBUN")).equals("01") || String.valueOf(ht.get("P_GUBUN")).equals("06") || String.valueOf(ht.get("P_GUBUN")).equals("02") || String.valueOf(ht.get("P_GUBUN")).equals("04") || String.valueOf(ht.get("P_GUBUN")).equals("11") || String.valueOf(ht.get("P_GUBUN")).equals("12") || String.valueOf(ht.get("P_GUBUN")).equals("13") || String.valueOf(ht.get("P_GUBUN")).equals("21") || String.valueOf(ht.get("P_GUBUN")).equals("31") || String.valueOf(ht.get("P_GUBUN")).equals("35") || String.valueOf(ht.get("P_GUBUN")).equals("37") || String.valueOf(ht.get("P_GUBUN")).equals("41")){//자동차대금,할부금,과태료%>
		    <a href="javascript:parent.view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="클릭하세요">보기</a>
		  <%}else if(String.valueOf(ht.get("P_GUBUN")).equals("99") && !String.valueOf(ht.get("FILE_CNT")).equals("0")){%>
		    <a href="javascript:parent.view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=String.valueOf(ht.get("FILE_CNT"))%>건</a>		  
		  <%}else if(String.valueOf(ht.get("P_GUBUN")).equals("99") && String.valueOf(ht.get("FILE_CNT")).equals("0")){%>
		    <a href="javascript:parent.view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="클릭하세요">등록</a>		  
		  <%}else{%>
		  <%	if(String.valueOf(ht.get("FILE_CNT")).equals("0")){%>
		    <a href="javascript:parent.view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="클릭하세요">등록</a>
		  <%	}else{%>
		    <a href="javascript:parent.view_pay_ledger_doc('<%=ht.get("REQSEQ")%>','<%=ht.get("P_GUBUN")%>','<%=ht.get("P_CD1")%>','<%=ht.get("P_CD2")%>','<%=ht.get("P_CD3")%>','<%=ht.get("P_CD4")%>','<%=ht.get("P_CD5")%>','<%=ht.get("P_ST1")%>','<%=ht.get("P_ST4")%>','<%=ht.get("I_CNT")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=String.valueOf(ht.get("FILE_CNT"))%>건</a>
		  <%	}%>
		  <%}%>
		  </td>         		  
  		  <td width='200' align='center'><a href="javascript:parent.view_pay_ledger('<%=ht.get("REG_END")%>','<%=ht.get("REQSEQ")%>', '<%=ht.get("P_GUBUN")%>', <%=ht.get("P_STEP")%>)" onMouseOver="window.status=''; return true" title="<%=ht.get("P_CONT")%>" ><%=ht.get("GUBUN_NM")%></a>
		  <%if(String.valueOf(ht.get("GUBUN_NM")).equals("영업수당") && String.valueOf(ht.get("P_ST4")).equals("vat")){%>
		  (vat)
		  <%}%> 
		  <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("입금담당",user_id) || nm_db.getWorkAuthUser("출금담당",user_id) || nm_db.getWorkAuthUser("보험업무",user_id)){%>
		  &nbsp;<a href="javascript:parent.view_pay_ledger2('<%=ht.get("REG_END")%>','<%=ht.get("REQSEQ")%>', '<%=ht.get("P_GUBUN")%>', <%=ht.get("P_STEP")%>)">.</a>
		  <%}%>
		  </td>
          <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_PAY_DT")))%></td>		  
          <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("P_EST_DT")))%></td>		  		  
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
	<td class='line' width='790'>
	  <table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <%	for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				//은행코드 가져오기
				if(String.valueOf(ht.get("BANK_ID")).equals("")){
					
				}
				total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT")));
				total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("COMMI")));
				%>
		<tr>
		  <td width='200' align='center'>
		  <%if(String.valueOf(ht.get("GUBUN_NM")).equals("영업수당") && String.valueOf(ht.get("P_ST4")).equals("vat") && !String.valueOf(ht.get("OFF_NM")).equals(String.valueOf(ht.get("VEN_NAME")))){%>
		  <span title='<%=ht.get("OFF_NM")%> <%=ht.get("VEN_NAME")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM"))+" "+String.valueOf(ht.get("VEN_NAME")), 15)%></span>
		  <%}else{%> 
		  <span title='<%=ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(ht.get("OFF_NM")), 15)%></span>
		  <%}%> 
		  </td>
          <td width='80' align='center'><%=ht.get("WAY_NM")%></td>         		
		  <td width='110' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT")))%></td>
		  <td width='80' align='center'><%=ht.get("USER_NM1")%></td>
		  <td width='80' align='center'><%=ht.get("USER_NM2")%></td>
		  <td width='80' align='center'>
		  <%if(String.valueOf(ht.get("USER_NM3")).equals("사후결재")){%>
		  <a href="javascript:parent.pay_doc_action('<%=ht.get("DOC_CODE")%>', '<%=ht.get("P_EST_DT")%>', '<%=ht.get("P_GUBUN")%>', '<%=ht.get("BR_ID")%>', '3', '<%=ht.get("DOC_NO11")%>','<%=ht.get("P_REQ_DT")%>', '<%=ht.get("P_EST_DT2")%>');" onMouseOver="window.status=''; return true"><%=ht.get("USER_NM3")%></a>
		  <%}else{%>
		  <%=ht.get("USER_NM3")%>
		  <%}%>
		  </td>		  
		  <td width='80' align='center'><%=ht.get("D_USER_NM1")%></td>
		  <td width='80' align='center'>
		  <%if(String.valueOf(ht.get("D_USER_NM2")).equals("사후결재")){%>
		  <a href="javascript:parent.doc_action('2', '<%=ht.get("BANK_CODE")%>', '<%=ht.get("DOC_NO22")%>');"><%=ht.get("D_USER_NM2")%></a>
		  <%}else{%>
		  <%=ht.get("D_USER_NM2")%>
		  <%}%>		  
		  </td>
		</tr>	
<%		}	%>
				<tr>						    
				    <td class='title'>합계</td>		
				    <td class='title'>&nbsp;</td>
					  <td class='title' style='text-align:right;'><%=AddUtil.parseDecimalLong(total_amt1)%></td>
					  <td class='title' style='text-align:right;'></td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				    <td class='title'>&nbsp;</td>
				</tr>
	  </table>
	</td>
<%	}else{%>                     
    <tr>
	    <td class='line' width='540' id='td_con' style='position:relative;'> 
	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td align='center'>등록된 데이타가 없습니다</td>
                </tr>
                </table>
	    </td>
	    <td class='line' width='790'>
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

