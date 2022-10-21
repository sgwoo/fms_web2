<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String param 	= request.getParameter("param")==null? "":request.getParameter("param");

	String[] params = param.split(",");
%>
<html>
<head><title>FMS</title>
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript">
//계출번호, 출고예정일자, 출고일자 수정(출고예정일자는 출고일자와 같게 업데이트됨)
function saveAll(){
	var fm = document.form1;
	if(confirm('현재 계출번호, 출고일자, 세금계산서일자, 계산서금액점검일자 정보 그대로 일괄 수정 됩니다.\n\n출고예정일자는 출고일자로 자동 수정됩니다.\n\n수정하시겠습니까?')){
		var fn = "save_all";		
		fm.action='reg_all_tax_invoice_a.jsp?fn='+fn;		
		fm.target='i_no';			
		fm.submit();
	}
}

//계출번호 일괄 수정
/* 미사용
function saveRpt_no(){
	var fm = document.form1;
	if(confirm('현재 계출번호 정보 그대로 일괄 수정 됩니다. 수정하시겠습니까?')){
		var fn = "save_rpt_no";		
		fm.action='reg_all_tax_invoice_a.jsp?fn='+fn;		
		fm.target='i_no';			
		fm.submit();
	}
}
*/

//출고예정일자 일괄 수정
/* 미사용
function saveDlv_est_dt(){
	var fm = document.form1;
	if(confirm('현재 출고예정일자 정보 그대로 일괄 수정 됩니다. 수정하시겠습니까?')){
		var fn = "save_dlv_est_dt";		
		fm.action='reg_all_tax_invoice_a.jsp?fn='+fn;		
		fm.target='i_no';			
		fm.submit();
	}
}
*/

//출고일자 일괄 수정
/* 미사용
function saveDlv_dt(){
	var fm = document.form1;
	if(confirm('현재 출고일자 정보 그대로 일괄 수정 됩니다. 수정하시겠습니까?')){
		var fn = "save_dlv_dt";		
		fm.action='reg_all_tax_invoice_a.jsp?fn='+fn;		
		fm.target='i_no';			
		fm.submit();
	}
}
*/

//세금계산서 스캔등록
function saveFile(idx){
//	var l_cd = $("#l_cd"+idx).val();
	var rpt_no = $("#rpt_no"+idx).val();
	var contentSeq = $("#contentSeq"+idx).val() + "1"+"10"  //앞 1 : 신규계약 , 뒤 10 : 스캔파일 종류(세금계산서)
//	window.open("/fms2/car_pur/reg_all_tax_invoice_scan.jsp?l_cd="+l_cd+"&contentSeq="+contentSeq,'savePop','width=500,height=180,top=0,left=100,scrollbars=no');
	window.open("/fms2/car_pur/reg_all_tax_invoice_scan.jsp?rpt_no="+rpt_no+"&contentSeq="+contentSeq,'savePop','width=500,height=180,top=0,left=100,scrollbars=no');
}

//세금계산서 스캔삭제
function delFile(idx){
	var seq = $("#seq"+idx).val();
	window.open("https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ="+seq,'delPop','width=700,height=300,top=0,left=100,scrollbars=no');
}

//스캔파일보기
/* 미사용
function openPopP(type,seq){	
	var isImage = type.indexOf("image/") != -1 ? true : false;
	var isPDF = type.indexOf("/pdf") != -1 ? true : false;
	var url = 'https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp';
	if( isImage || isPDF ){
		if(type.indexOf("image/") != -1 ) {				
			url = 'https://fms3.amazoncar.co.kr/fms2/attach/imgview_print.jsp';
		}						
		url = url + "?SEQ=" + seq;
		var popName = "view_file";
		var aTagObj = document.getElementById("link_view_a");		
		if( aTagObj == null ){			
			var aTag = document.createElement("a");
			aTag.setAttribute("href", url);
			aTag.setAttribute("target",popName);
			aTag.setAttribute("id","link_view_a");
			target = document.getElementsByTagName("body");
			target[0].appendChild(aTag);
			aTagObj = document.getElementById("link_view_a");		
		}else{		
			aTagObj.setAttribute("href", url);
		}		
		var pop = window.open('', popName, "left=300, top=250, width=1000, height=1000, scrollbars=yes");		
		aTagObj.click();		
	}else{
		alert('보기를 할수없는 파일입니다.');
	} 	
}
*/

//스캔파일보기
function openPopP_tax(save_file,save_folder,m_id,l_cd){	
	var url = '/acar/car_register/register_pur_id_tax.jsp';
	url = url + "?save_file=" + save_file + "&save_folder=" + save_folder + "&rent_mng_id="+m_id+"&rent_l_cd="+l_cd;
	window.open(url, "PopP_tax", "left=300, top=250, width=1000, height=1000, scrollbars=yes");		
}
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
<table width=1100 border=0 cellpadding=0 cellspacing=0>
    <tr>
        <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
        <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>세금계산서 및 출고일자 일괄등록</span></span></td>
        <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
    </tr>
    <tr height="10px;"></tr>
</table>
<div style="font-size: 13px; padding-bottom: 10px; float: left;">
	<div>※ 출고일자 중 빨간숫자는 출고일자가 입력되지 않아 출고예정일자를 가져온 값입니다. 저장시 그대로 출고일자에 반영됩니다.</div>
	<div>※ 세금계산서일자 중 빨간숫자는 세금계산서일자가 입력되지 않아 출고일자 혹은 출고예정일자를 가져온 값입니다. 저장시 그대로 세금계산서일자에 반영됩니다.</div>
	<div>※ 계산서금액점검일자 중 빨간숫자는 계산서금액점검일자가 입력되지 않아 당일일자를 가져온 값입니다. 저장시 그대로 계산서금액점검일자에 반영됩니다.</div>
	<div>※ 계출번호, 출고예정일자, 출고일자, 세금계산서일자, 계산서금액점검일자 수정시 자동 새로고침이 되지만, 스캔파일등록/삭제시에는 필요에 따라 직접 새로고침을 해주세요.</div>
	<div>※ 세금계산서일자, 계산서금액점검일자를 미입력하고 싶으면 값을 지우고 수정하세요.</div>
</div>	
<div align="right" style="position: relative; margin-right: 35px;">
	<input type="button" class="button" value="수정" onclick="javascript:saveAll()">&nbsp;&nbsp;&nbsp; 
	<input type="button" class="button" value="새로고침" onclick="javascript:window.location.reload();">
</div>
<table border="0" cellspacing="0" cellpadding="0" width='1100'>
    <tr>
        <td colspan="2" class=line2></td>
    </tr>  
	<tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='1100' id='td_title' style='position:relative;'>
			<table border="0" cellspacing="1" cellpadding="0" width='100%'>
			    <tr>
			        <td width='40' class='title' style='height:51'>연번</td>
	                <td width="100" class='title'>계약번호</td>
	                <td width="140" class='title'>계출번호</td>
	                <td width="100" class='title'>차량가격</td>
	                <td width="100" class='title'>출고예정일자</td>
	                <td width="100" class='title'>출고일자</td>
	                <td width="100" class='title'>세금계산서일자</td>
	                <td width="100" class='title'>계산서금액<br>점검일자</td>
	                <td width="310" class='title' colspan="3">세금계산서 스캔등록</td>
			    </tr>
			</table>
		</td>
	</tr>
	<%
	for(int i=0; i<params.length; i++){
		
		Vector vt = a_db.getRegAllTaxInvoiceList(params[i]);		
		int vt_size = vt.size();
		
		for(int j = 0 ; j < vt_size ; j++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(j);
			String m_id = ht.get("RENT_MNG_ID").toString();
			String l_cd = ht.get("RENT_L_CD").toString();
			String contentSeq = "" + m_id + l_cd + "%";
			
			Vector vt2 = a_db.getRegAllTaxInvoiceScan(contentSeq);		
			int vt_size2 = vt2.size();	
	%>
			<tr>
				<td class='line' width='970' id='td_con' style='position:relative;'>
					<table border="0" cellspacing="1" cellpadding="0" width='100%'>
						<tr>
							<td  width='40' align='center' style='height:30'>
								<%=i+1%>
								<input type="hidden" name="m_id" value="<%=ht.get("RENT_MNG_ID")%>" >
								<input type="hidden" name="l_cd" id="l_cd<%=i%>" value="<%=ht.get("RENT_L_CD")%>" >
							</td>
							<td  width='100' align='center'><%=ht.get("RENT_L_CD")%></td>										
							<td  width='140' align='center'>
								<input type="text" name="rpt_no" id="rpt_no<%=i%>" value="<%=ht.get("RPT_NO")%>" size="15" style="text-align: center;">
							</td>
							<td  width='100' align='center'><%=ht.get("TOT_F_AMT")%> 원</td>	
							<td  width='100' align='center'>
								<input type="text" name="dlv_est_dt" value="<%=ht.get("DLV_EST_DT")%>" size="10" style="text-align: center;">
							</td>
							<!-- 출고일자 -->
							<%	if(ht.get("DLV_DT")!=null && !ht.get("DLV_DT").equals("")){%>								
							<td  width='100' align='center'>
								<input type="text" name="dlv_dt" value="<%=ht.get("DLV_DT")%>" size="10" style="text-align: center;">
							</td>	
                            <%	}else{%>					
							<td  width='100' align='center'>
								<input type="text" name="dlv_dt" value="<%=ht.get("DLV_EST_DT")%>" size="10" style="text-align: center; color: red;">
							</td>			
                            <%	}%>
                            <!-- 세금계산서일자 -->
                            <%	if(String.valueOf(ht.get("CAR_TAX_DT")).equals("")){%>
                            <%		if(ht.get("DLV_DT")!=null && !ht.get("DLV_DT").equals("")){%>								
							<td  width='100' align='center'>
								<input type="text" name="car_tax_dt" value="<%=ht.get("DLV_DT")%>" size="10" style="text-align: center; color: red;">
							</td>	
                            <%		}else{%>					
							<td  width='100' align='center'>
								<input type="text" name="car_tax_dt" value="<%=ht.get("DLV_EST_DT")%>" size="10" style="text-align: center; color: red;">
							</td>			
                            <%		}%>                            
							<%	}else{%>
							<td  width='100' align='center'>
								<input type="text" name="car_tax_dt"  value="<%=ht.get("CAR_TAX_DT")%>" size="10" style="text-align: center;">
							</td>								
							<%	}%>
							<!-- 계산서금액점검일자 -->
							<%	if(String.valueOf(ht.get("CAR_AMT_DT")).equals("")){%>
							<td  width='100' align='center'>
								<input type="text" name="car_amt_dt" value="<%=AddUtil.getDate(1)%><%=AddUtil.getDate(2)%><%=AddUtil.getDate(3)%>" size="10" style="text-align: center; color: red;">
							</td>
							<%	}else{%>
							<td  width='100' align='center'>
								<input type="text" name="car_amt_dt" value="<%=ht.get("CAR_AMT_DT")%>" size="10" style="text-align: center;">
							</td>							
							<%	}%>
							<!-- 스캔파일 -->
                            <% if(vt_size2 > 0){
				          			for(int k = 0 ; k < vt_size2 ; k++){
										Hashtable ht2 = (Hashtable)vt2.elementAt(k);
                            %>
							<td  width='255' align='center'>	
								<!-- <a href="javascript:openPopP('<%=ht2.get("FILE_TYPE")%>','<%=ht2.get("SEQ")%>');" title='보기' ><%=ht2.get("FILE_NAME")%></a> -->
								<a href="javascript:openPopP_tax('<%=ht2.get("SAVE_FILE")%>','<%=ht2.get("SAVE_FOLDER")%>','<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" title='보기' ><%=ht2.get("FILE_NAME")%></a>
							</td>
							<td  width='55' align='center'>
								<a href="#" onclick="javascript:delFile(<%=i%>)"><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
								<input type="hidden" id="seq<%=i%>" value="<%=ht2.get("SEQ")%>">
								<input type="hidden" id="contentSeq<%=i%>" value="<%=contentSeq%>">
							</td>
                            <%		}
								}else{%>
							<td  width='255' align='center' colspan="2">스캔파일 미등록</td>
							<td  width='55' align='center'>
								<a href="#" onclick="javascript:saveFile(<%=i%>)"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
								<input type="hidden" id="contentSeq<%=i%>" value="<%=m_id%><%=l_cd%>">
							</td>
                            <%	}%>							
						</tr>
					</table>
				</td>
			</tr>
<%
			}
		}	
%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>