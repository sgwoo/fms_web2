<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String st	 	= request.getParameter("st")==null?"":request.getParameter("st");
	
	
	
	PayMngDatabase pm_db = PayMngDatabase.getInstance();
	
	
	Vector vt = pm_db.getPayDoc31LastList2(st);
	int vt_size = vt.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&st_dt="+st_dt+"&end_dt="+end_dt+"&gubun3="+gubun3+"&gubun4="+gubun4+
				   	"";
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
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
	
	//보기
	function view_pay_ledger(reg_end, p_gubun, reqseq, i_seq, amt){
		window.open("pay_upd_step2.jsp<%=valus%>&mode=view&reqseq="+reqseq, "VIEW_PAY_LEDGER", "left=150, top=150, width=900, height=700, scrollbars=yes");			
	}	
	
	//문서 취소
	function doc_del(doc_no){
		var fm = document.form1;	
		
		if(confirm('삭제하시겠습니까?')){
		if(confirm('진짜로 삭제하시겠습니까?')){		
			fm.doc_no.value = doc_no;
			fm.action='/fms2/doc_settle/doc_cancel_a.jsp';
			fm.target='i_no';
			fm.submit();
		}}
	}		
	
	//일괄결재하기
	function doc_all_sanction(){
		var fm = document.form1;	
		
		if(confirm('결재하시겠습니까?')){		
			fm.action='pay_doc_all_last_app_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
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
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">
  <input type='hidden' name="st" 		value="<%=st%>">  
  <input type='hidden' name="doc_no" 	value="">  


<table border="0" cellspacing="0" cellpadding="0" width=980>
    <tr>
        <td><< 사후결재 일괄처리 >></td>
    </tr>  
	<tr>
		<td class=h></td>
	</tr>  		
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출금기안</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
        			<td width='30' class='title' rowspan='2'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>				
        			<td width='30' class='title' rowspan='2'>연번</td>
        		    <td width="80" class='title' rowspan='2'>기안일자</td>					
					<td width="60" class='title' rowspan='2'>기안자</td>
					<td class='title' colspan='7'>내용
				</tr>
				<tr>
						  <td width='30' class='title'>연번</td>
					      <td width="70" class='title'>거래일자</td>					
        		          <td width="70" class='title'>출금방식</td>
        		          <td width='110' class='title'>출금항목</td>
        		          <td width="150" class='title'>지출처</td>					
               		      <td width='100' class='title'>금액</td>
               		      <td width='250' class='title'>적요</td>        								  
       		    </tr>		
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i); 
						
						Vector l_vt = pm_db.getPayDocList(String.valueOf(ht.get("DOC_ID")), "app_st", st, "", String.valueOf(ht.get("DOC_NO")));
						int l_vt_size = l_vt.size();
						
						if(l_vt_size==0)  continue;
						
						total_amt1 = 0;
						%>
		        <tr>
        			<td align="center"><input type="checkbox" name="ch_cd" value="<%=ht.get("DOC_NO")%>"></td>				
        			<td align="center"><%=i+1%></td>
        		    <td align="center"><%=ht.get("REG_DT")%></td>					
					<td align="center"><%=ht.get("REG_NM")%></td>
					<td align="center" class='line3' colspan='7'>
					  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
						<%	for(int j = 0 ; j < l_vt_size ; j++){
								Hashtable l_ht = (Hashtable)l_vt.elementAt(j); %>
					    <tr>
						  <td width='30' align="center"><%=j+1%></td>
						  <td width='70' align='center'><a href="javascript:parent.view_pay_ledger('<%=l_ht.get("REG_END")%>','<%=l_ht.get("P_GUBUN")%>','<%=l_ht.get("REQSEQ")%>','<%=l_ht.get("I_SEQ")%>','<%=l_ht.get("AMT")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=AddUtil.ChangeDate2(String.valueOf(l_ht.get("P_EST_DT")))%></a></td>
						  <td width='70' align='center'><%=l_ht.get("WAY_NM")%></td>
						  <td width='110' align='center'><%=l_ht.get("GUBUN_NM")%></td>
						  <td width='150' align='center'><span title='<%=l_ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(l_ht.get("OFF_NM")), 12)%></span></td>
						  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(l_ht.get("AMT")))%></td>
						  <td width='250'>&nbsp;<span title='<%=l_ht.get("P_CONT")%>'><%=Util.subData(String.valueOf(l_ht.get("P_CONT")), 20)%></span></td>						  						  						  
						</tr>						
						<%		total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(l_ht.get("AMT")));
							}%>
						<%	if(l_vt_size>1){%>
					    <tr>
						  <td colspan='5' align="center">소계</td>
						  <td align='right'><%=AddUtil.parseDecimalLong(total_amt1)%></td>
						  <td>&nbsp;</td>						  						  						  
						</tr>								
						<%	}%>
						<%	if(l_vt_size==0){%>
					    <tr>
						  <td align="center">세부 리스트가 없습니다. (doc_code:<%=ht.get("DOC_ID")%> <a href="javascript:doc_del('<%=ht.get("DOC_NO")%>');">[취소]</a>)</td>
						</tr>												
						<%	}%>
					  </table>
					</td>					
       		    </tr>								
				<%		total_amt2 	= total_amt2 + total_amt1;
					}%>		
				<tr>
				  <td colspan='9' class='title'>총합계</td>
				  <td align='right' class='title'><%=AddUtil.parseDecimalLong(total_amt2)%></td>
				  <td class='title'>&nbsp;</td>						  						  						  
				</tr>									
		    </table>
	    </td>
    </tr>  
	<%
		total_amt1 = 0;
		total_amt2 = 0;
		
		vt = pm_db.getPayDoc32LastList2(st);
		vt_size = vt.size();
	%>
	<tr>
		<td>&nbsp;</td>
	</tr>  		
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>송금요청</span></td>
    </tr>  
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
        <td class='line'>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
        			<td width='30' class='title' rowspan='2'>선택</td>				
        			<td width='30' class='title' rowspan='2'>연번</td>
        		    <td width="80" class='title' rowspan='2'>기안일자</td>					
					<td width="60" class='title' rowspan='2'>기안자</td>
					<td class='title' colspan='7'>내용
				</tr>
				<tr>
						  <td width='30' class='title'>연번</td>
					      <td width="70" class='title'>거래일자</td>					
        		          <td width="70" class='title'>출금방식</td>
        		          <td width='110' class='title'>출금항목</td>
        		          <td width="150" class='title'>지출처</td>					
               		      <td width='100' class='title'>금액</td>
               		      <td width='250' class='title'>적요</td>        								  
       		    </tr>		
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i); 
						
						Vector l_vt = pm_db.getPayActDocBankCodeList2(String.valueOf(ht.get("DOC_ID")), String.valueOf(ht.get("DOC_NO")), st);
						int l_vt_size = l_vt.size();
						
						if(l_vt_size==0)  continue;
						
						total_amt1 = 0;
						%>
		        <tr>
        			<td align="center"><input type="checkbox" name="ch_cd" value="<%=ht.get("DOC_NO")%>"></td>				
        			<td align="center"><%=i+1%></td>
        		    <td align="center"><%=ht.get("REG_DT")%></td>					
					<td align="center"><%=ht.get("REG_NM")%></td>
					<td align="center" class='line3' colspan='7'>
					  <table border="0" cellspacing="0" cellpadding="0" width='100%'>
						<%	for(int j = 0 ; j < l_vt_size ; j++){
								Hashtable l_ht = (Hashtable)l_vt.elementAt(j); %>
					    <tr>
						  <td width='30' align="center"><%=j+1%></td>
						  <td width='70' align='center'><a href="javascript:parent.view_pay_ledger('<%=l_ht.get("REG_END")%>','<%=l_ht.get("P_GUBUN")%>','<%=l_ht.get("REQSEQ")%>','<%=l_ht.get("I_SEQ")%>','<%=l_ht.get("AMT")%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=AddUtil.ChangeDate2(String.valueOf(l_ht.get("P_EST_DT")))%></a></td>
						  <td width='70' align='center'><%=l_ht.get("WAY_NM")%></td>
						  <td width='110' align='center'><%=l_ht.get("GUBUN_NM")%></td>
						  <td width='150' align='center'><span title='<%=l_ht.get("OFF_NM")%>'><%=Util.subData(String.valueOf(l_ht.get("OFF_NM")), 12)%></span></td>
						  <td width='100' align='right'><%=AddUtil.parseDecimalLong(String.valueOf(l_ht.get("AMT")))%></td>
						  <td width='250'>&nbsp;<span title='<%=l_ht.get("P_CONT")%>'><%=Util.subData(String.valueOf(l_ht.get("P_CONT")), 20)%></span></td>						  						  						  
						</tr>						
						<%		total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(l_ht.get("AMT")));
							}%>
						<%	if(l_vt_size>1){%>
					    <tr>
						  <td colspan='5' align="center">소계</td>
						  <td align='right'><%=AddUtil.parseDecimalLong(total_amt1)%></td>
						  <td>&nbsp;</td>						  						  						  
						</tr>								
						<%	}%>
						<%	if(l_vt_size==0){%>
					    <tr>
						  <td align="center">세부 리스트가 없습니다. (bank_code:<%=ht.get("DOC_ID")%> <a href="javascript:doc_del('<%=ht.get("DOC_NO")%>');">[취소]</a>)</td>
						</tr>												
						<%	}%>
					  </table>
					</td>					
       		    </tr>								
				<%		total_amt2 	= total_amt2 + total_amt1;
					}%>		
				<tr>
				  <td colspan='9' class='title'>총합계</td>
				  <td align='right' class='title'><%=AddUtil.parseDecimalLong(total_amt2)%></td>
				  <td class='title'>&nbsp;</td>						  						  						  
				</tr>									
		    </table>
	    </td>
    </tr>  	
	<tr>
	  <td>&nbsp;</td>
    </tr>	
	<tr>
	  <td align="center">
  	    <a href="javascript:doc_all_sanction()"><img src="/acar/images/center/button_gj.gif" align="absmiddle" border="0"></a>
	  </td>
    </tr>		
	
</table>
</form>  
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
