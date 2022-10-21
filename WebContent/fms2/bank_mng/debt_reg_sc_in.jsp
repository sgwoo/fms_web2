<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.bank_mng.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String bank_id = request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	
	int alt_amt = 0;
	
	Vector bank_lends = abl_db.getBankLendList(st_dt,end_dt, bank_id);
	int bl_size = bank_lends.size();
	
	int reg_amt = 0;
	int no_m_amt = 0;
	
	long t_amt = 0;
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
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
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	
	
		//전체선택
			
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){		
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
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form  name="form1" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="100%">            	
            	<tr>
            		<td class=line>
            			<table border=0 cellspacing=1 width=100%>
                            <tr>
                             	<td width=3% class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td> 
                              	<td width=4% class=title >연번</td>	
			                    <td width=8% class=title>계약번호</td>
			                    <td width=7% class=title>계약일</td>
			                    <td width=12% class=title>금융사</td>
			                    <td width=10% class=title>지점(차량번호)</td>
			                    <td width=4% class=title>구분</td>
			                    <td width=12% class=title>고객</td>
			                    <td width=9% class=title>대출금액</td>
			                    <td width=4% class=title>이율</td>
			                    <td width=7% class=title>상환개시일</td>
			                    <td width=4% class=title>기간</td>
			                	
                            </tr>
                      <%	if(bl_size > 0){%>
                         <%for(int i = 0 ; i < bl_size ; i++){
								Hashtable bank_lend = (Hashtable)bank_lends.elementAt(i);
														
								String rtn_su = String.valueOf(bank_lend.get("RTN_SU"));
								String rtn_st = String.valueOf(bank_lend.get("RTN_ST"));
								String scd_yn = String.valueOf(bank_lend.get("SCD_YN"));
								String rtn_change = String.valueOf(bank_lend.get("RTN_CHANGE"));         
								
								if(String.valueOf(bank_lend.get("CONT_BN")).equals("0016") && String.valueOf(bank_lend.get("CONT_AMT")).equals("0")){
				        					t_amt  +=  AddUtil.parseLong(String.valueOf(bank_lend.get("PM_REST_AMT")));
				        		  		} else{
				        		  	                  t_amt  +=  AddUtil.parseLong(String.valueOf(bank_lend.get("CONT_AMT")));		  
				        		  	    }																		
								                        		
                    	  %>
                            <tr> 
                           		<input type="hidden" name="ven_code" value="<%=bank_lend.get("VEN_CODE")%>" >
                           		<input type="hidden" name="acct_code" value="<%=bank_lend.get("ACCT_CODE")%>" >
                           		<input type="hidden" name="scd_cnt" value="<%=bank_lend.get("SCD_CNT")%>" >
                           		<input type="hidden" name="debt_amt" value="<%=bank_lend.get("DEBT_AMT")%>" >
                           		 
                            	<td align='center'> 
              						<input type="checkbox" name="ch_l_cd" value="<%=i%>^<%=bank_lend.get("CPT_CD")%>^<%=bank_lend.get("LEND_ID")%>^<%=bank_lend.get("CONT_DT")%>^<%=bank_lend.get("GUBUN")%>^" <% if (bank_lend.get("F_ACCT_YN").equals("Y") ) {%> disabled <% } %> > 
            					</td>
                                <td align="center"><%=i+1%></td>
                                <td align="center"><%=bank_lend.get("LEND_ID")%></td>
                                <td align="center"><%=bank_lend.get("CONT_DT")%></td>
                                <td align="center"><%= bank_lend.get("BANK_NM") %>(<%= bank_lend.get("VEN_CODE") %>)</td>
                                <td align="left"><span title='<%=bank_lend.get("BN_BR")%>'><%=Util.subData(String.valueOf(bank_lend.get("BN_BR")), 9)%></span>
                                <%if(String.valueOf(bank_lend.get("GUBUN")).equals("3")){%>(기타비용)<%}%>	      
                                </td>
                			    <td align="center"><%=bank_lend.get("ACCT_CODE")%></td>
                			    <td align="center"><%=bank_lend.get("FIRM_NM")%></td> 
                			    <td align="right">
                			     <%if(String.valueOf(bank_lend.get("CONT_BN")).equals("0016") && String.valueOf(bank_lend.get("CONT_AMT")).equals("0")){%>
				        			<%=Util.parseDecimalLong(String.valueOf(bank_lend.get("PM_REST_AMT")))%>  
				        		  <%}else{%>
				        		  	<%=Util.parseDecimalLong(String.valueOf(bank_lend.get("CONT_AMT")))%> 		  
				        		  <%}%>					  
				        		</td>
                                                             
                                <td align="right"><%=bank_lend.get("LEND_INT")%></td>
                                <td align="center"><%=bank_lend.get("CONT_START_DT")%></td>
                                <td align="right"><%=bank_lend.get("CONT_TERM")%></td>
                                               			  
                            </tr>
                          <%	}%>
                          	   <tr> 
            	                <td colspan="8"  class=title align="center">합계</td>
            	                <td width='120'  class=title style='text-align:right'><%=Util.parseDecimalLong(t_amt)%></td>	
            	                <td colspan="3"  class=title align="center">&nbsp;</td>		
            	  
            	            </tr>
                          <%}%>			  
            			  <%if(bl_size == 0){ %>			  
                            <tr> 
                                <td colspan="14" align="center">&nbsp;등록된 데이타가 없습니다.</td>
                            </tr>
            			  <%}%>			  
                       </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    
    
</table>
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type='hidden' name='lend_id' value=''>
<input type='hidden' name='rtn_seq' value=''>
<input type='hidden' name='cont_term' value=''>
<input type='hidden' name='scd_yn_r' value=''>
<input type='hidden' name='rtn_seq_r' value=''>
<input type='hidden' name='bank_id' value='<%=bank_id%>'>
<input type='hidden' name='lend_id' value=''>
<input type="hidden" name="cmd" value="">
<input type="hidden" name="debt_size" value='<%=bl_size%>'>
<script language='javascript'>
<!--
	parent.document.form1.size.value = '<%=bl_size%>';
//-->
</script>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>

</body>
</html>


