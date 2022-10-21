<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, tax.*, acar.bill_mng.*, acar.user_mng.*"%>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	String year = st_dt+end_dt;
	
	//발행작업스케줄
	Vector fee_scd = ScdMngDb.getFeeScdNoTax(s_br, st_dt, end_dt, s_kd, t_wd1);
	int fee_scd_size = fee_scd.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//미발행건수 연결
	function issue(reg_yn, print_st, req_dt, rent_l_cd){
		var fm = document.form1;
  	fm.gubun1.value = "1";
  	fm.st_dt.value = req_dt;
  	fm.end_dt.value = req_dt;
  	fm.s_kd.value = "2";
  	fm.t_wd1.value = rent_l_cd;
		if(print_st == '계약건별'){
	  	fm.action = '/tax/issue_1/issue_1_frame.jsp';
		}else{
	  	fm.action = '/tax/issue_2/issue_2_frame.jsp';
		}
 		fm.target = 'd_content';
 		fm.submit();
	}
	
	//선택출력
	function select_cng_dt(cng_st){
		var fm = parent.c_foot.document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("변경할 스케줄을 선택하세요.");
			return;
		}	
		fm.cng_dt.value = document.form1.cng_dt.value;
		fm.cng_st.value = cng_st;
		if(confirm('등록 하시겠습니까?')){	
			fm.target = "i_no";		
			fm.action = "fee_scd_dt_cng_a.jsp";
			fm.submit();	
		}
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
	
	//선택출력
	function select_cng_dt(cng_st){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("변경할 스케줄을 선택하세요.");
			return;
		}	
		fm.cng_st.value = cng_st;
		if(confirm('변경 하시겠습니까?')){	
			fm.target = "i_no";		
			fm.action = "fee_scd_dt_cng_a.jsp";
			fm.submit();	
		}
	}							
	
	//계산서일시중지관리
	function view_scd_fee(m_id, l_cd, rent_st){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.rent_st.value = rent_st;
		fm.auth_rw.value = <%=auth_rw%>;		
		//window.open("about:blank", "ScdList", "left=50, top=50, width=1050, height=800, scrollbars=yes");				
		fm.action = "/fms2/con_fee/fee_scd_u_frame.jsp";
//		fm.action = "/fms2/con_fee/fee_c_mgr.jsp";		
//		fm.action = "/fms2/con_fee/fee_scd_print.jsp";
		//fm.target = "ScdList";
		fm.target = "d_content";
		fm.submit();
	}		
	
	//계산서일시중지관리
	function view_scd_fee_stop(m_id, l_cd, seq){
		var fm = document.form1;
		fm.m_id.value = m_id;
		fm.l_cd.value = l_cd;
		fm.seq.value = seq;
		window.open("about:blank", "ScdStopList", "left=50, top=50, width=750, height=600, scrollbars=yes");				
		fm.action = "/fms2/con_fee/fee_scd_u_stoplist.jsp";
		fm.target = "ScdStopList";
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='fee_scd_size' value='<%=fee_scd_size%>'>
<input type='hidden' name='cng_st' value=''>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<input type='hidden' name='seq' value=''>
<input type='hidden' name='rent_st' value=''>

  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='4%' class='title'><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
            <td width='4%' class='title'>연번</td>
            <td width='6%' class='title'>발행구분</td>
            <td width='13%' class='title'>상호</td>
            <td width='8%' class='title'>차량번호</td>
            <td width='4%' class='title'>회차</td>
            <td width='8%' class='title'>입금예정일</td>			
            <td width='8%' class='title'>세금일자</td>						
            <td width='8%' class='title'>발행예정일</td>
            <td width='7%' class='title'>공급가</td>
            <td width='7%' class='title'>부가세</td>
            <td width='7%' class='title'>합계</td>
            <td width='6%' class='title'>연체구분</td>
            <td width='6%' class='title'>상태</td>			
            <td width='4%' class='title'>수금</td>						
          </tr>
<%		for(int i = 0 ; i < fee_scd_size ; i++){
			Hashtable ht = (Hashtable)fee_scd.elementAt(i);%>						  
          <tr>
            <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=ht.get("RENT_MNG_ID")%><%=ht.get("RENT_L_CD")%><%=ht.get("RENT_ST")%><%=ht.get("RENT_SEQ")%><%=ht.get("FEE_TM")%>"></td>
            <td align="center"><%=i+1%></td>
            <td align="center"><%=ht.get("PRINT_ST")%></td>
            <td align="center"><span title='<%=ht.get("FIRM_NM")%>(<%=ht.get("CLIENT_ID")%>)'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 7)%></span></td>
            <td align="center"><a href="javascript:view_scd_fee('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("RENT_ST")%>')" onMouseOver="window.status=''; return true" title='대여료스케줄관리 이동'><%=ht.get("CAR_NO")%></a></td>
            <td align="center"><%=ht.get("FEE_TM")%>회</td>			
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>			
            <td align="center"><a href="javascript:issue('N','<%=ht.get("PRINT_ST")%>','<%=ht.get("REQ_DT")%>','<%=ht.get("RENT_L_CD")%>')" title='대여료개별정기발행 이동'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></a></td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%>원&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_V_AMT")))%>원&nbsp;</td>
            <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원&nbsp;</td>
            <td align="center">
			<%if(AddUtil.parseInt(String.valueOf(ht.get("DLY_CNT"))) > 0){%>		  
			<%=ht.get("DLY_CNT")%>개월연체
		    <%}else{%>
		    -
		    <%}%>					
			</td>
            <td align="center">
			<%if(String.valueOf(ht.get("USE_YN")).equals("발행중지")){%>
			<a href="javascript:view_scd_fee_stop('<%=ht.get("RENT_MNG_ID")%>', '<%=ht.get("RENT_L_CD")%>', '<%=ht.get("SEQ")%>')" onMouseOver="window.status=''; return true" title='발행중지내용팝업'><%=ht.get("USE_YN")%></a>
		    <%}else{%>
		    <%=ht.get("USE_YN")%>
		    <%}%>			
			</td>			
            <td align="center"><%=ht.get("RC_YN_NM")%></td>						
          </tr>
<%		}%>	
<% 		if(fee_scd_size == 0){%>
		<tr>
		  <td colspan="14" align="center">등록된 데이타가 없습니다.</td>
		</tr>
<% 		}%>					  
        </table></td>
    </tr>
	<tr>
		<td class=h></td>
	</tr>   	
    <tr> 
      <td align="right">
	  <%if(nm_db.getWorkAuthUser("회계업무",user_id)){%>
	  &nbsp;변경일자 : <input type='text' name='cng_dt' value='' size='11' class=text>&nbsp;
	  <a href="javascript:select_cng_dt('req_dt');"><img src=/acar/images/center/button_ch_pub.gif border=0 align=absmiddle></a>&nbsp;&nbsp;
	  <%}%>
	  </td>	  
    </tr>		
  </table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

