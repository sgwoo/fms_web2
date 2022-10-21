<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*, acar.client.*, acar.settle_acc.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String client_id 	= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	
	
	
	//거래처
	ClientBean client = al_db.getClient(client_id);
%>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
	//팝업윈도우 열기
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		if(fm.gov_nm.value == '') { alert('수신기관을 확인하십시오.'); return; }
		window.open("about:blank",'search_open','scrollbars=yes,status=no,resizable=yes,width=800,height=500,left=50,top=50');		
		fm.action = "../pop_search/s_client.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&t_wd="+fm.gov_nm.value;
		fm.target = "search_open";
		fm.submit();		
	}
	
	//등록
	function doc_reg(){
		var fm = document.form1;
		
		if(fm.doc_id.value == '')		{ alert('문서번호를 입력하십시오.'); 	return; }
		if(fm.doc_dt.value == '')		{ alert('시행일자를 입력하십시오.'); 	return; }		
		if(fm.gov_id.value == '')		{ alert('수신기관을 선택하십시오.'); 	return; }		
		if(fm.gov_nm.value == '')		{ alert('수신기관을 선택하십시오.'); 	return; }
		if(fm.title.value == '')		{ alert('제목을 선택하십시오.'); 		return; }
		if(fm.filename2.value == '')	{ alert('스캔을 첨부하십시오.'); 		return; }		
		
		<%if(!client_id.equals("")){%>	
				
		if(fm.tax_yn.checked == true && (fm.stop_s_dt.value == '' || fm.stop_e_dt.value == '' || fm.stop_cau.value == '')){ alert('중지기간, 사유를 입력하십시오.'); return; }
		
		//if(!list_confirm()){				return;	}
		
		if(!confirm('등록하시겠습니까?')){	return;	}		
		fm.action = "https://fms3.amazoncar.co.kr/acar/upload/settle_doc_reg_sc_a.jsp";
		fm.target = "i_no";
		fm.submit()
		
		<%}%>
	}
	
	//미수채권 선택
	function list_confirm(){
		var fm = document.form1;
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name.indexOf("ch_l_cd") != -1){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		if(cnt == 0){
		 	alert("미수채권을 선택하세요.");
			return false;
		}else{
			return true;	
		}
	}
	
		//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}			
	
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post' enctype="multipart/form-data">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='size' value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width=12%>문서번호</td>
            <td> 
              &nbsp;&nbsp;<input type="text" name="doc_id" size="20" class="text" value="<%=FineDocDb.getSettleDocIdNext("채권추심")%>">
            </td>
          </tr>
          <tr> 
            <td class='title'>시행일자</td>
            <td> 
              &nbsp;&nbsp;<input type="text" name="doc_dt" size="11" class="text" value="<%=AddUtil.getDate()%>" onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
          </tr>
          <tr> 
            <td rowspan="2" class='title'>수신</td>
            <td> 
              &nbsp;&nbsp;<input type="text" name="gov_nm" value="<%=client.getFirm_nm()%>" size="50" class="text" style='IME-MODE: active'>
			  <input type='hidden' name="gov_id" value="<%=client_id%>">			 
			</td>
          </tr>
          <tr>
            <td>&nbsp;&nbsp;<input type="text" name="gov_addr" size="100" class="text" value="<%=client.getO_addr()%>">
              (주소) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
               <a href="javascript:MM_openBrWindow('settle_doc_f_result.jsp?client_id=<%=client_id%>','popwin_vacation','scrollbars=yes,status=no,resizable=yes,width=700,height=300,top=400,left=240')"><img src="/images/esti_detail.gif"  width="15" height="15" align="absmiddle" border="0" alt="반송주소리스트보기"></a>
              
              
              반송주소</td>
          </tr>
         
         
          <tr> 
            <td class='title'>참조</td>
            <td> 
              &nbsp;&nbsp;<input type="text" name="mng_dept" size="50" class="text" value="대표이사 <%=client.getClient_nm()%>"> 
              </td>
          </tr>
          <tr> 
            <td class='title'>제목</td>
            <td>&nbsp; <select name='title'>
           <!--       <option value=''>선택</option>
              <option value="최고장">최고장</option>				  
                 <option value="납입최고 및 해지예고">납입최고 및 해지예고</option>	 			  
				  <option value="해지예고통보">해지예고통보</option>				  
				  <option value="해지통보">해지통보</option>				  
                <option value="해지통보 및 중도위약금 납입고지">해지통보 및 중도위약금 납입고지</option> 
                 <option value="계약해지 및 차량반납 통보">계약해지 및 차량반납 통보</option> -->
                  <option value="기타">기타</option>				  
               </select>
			   <input type="text" name="title_sub" size="40" class="text" value="">&nbsp;<font color='#CCCCCC'>(기타일때)</font>
			   </td>
          </tr>
          <tr> 
            <td class='title'>유예기간</td>
            <td>&nbsp;&nbsp;<input type="text" name="end_dt" size="11" class="text" value="" onBlur='javscript:this.value = ChangeDate(this.value);'></td>
          </tr>
          <tr> 
            <td class='title'>스캔</td>
            <td>&nbsp;&nbsp;<input type="file" name="filename2" size="40"></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
        <td></td>
    </tR>
	<%if(!client_id.equals("")){%>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <font color="red"><b>미수채권</b></font></td>
    </tr>		
	<%	Vector settles = s_db.getSettleList3("", "", "", "", "", "", "1", client.getFirm_nm());
		int settle_size = settles.size();
	%>
	<script language='javascript'>
	<!--	
		document.form1.size.value = <%=settle_size%>;
	//-->
	</script>
	<tr>
        <td class=line2></td>
    </tr>
    <tr>
      <td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td class='title' width="4%" >선택</td>
            <td class='title' width="12%">계약번호</td>
            <td class='title' width="12%">차량번호</td>
            <td class='title' width="12%">선수금</td>
            <td class='title' width="12%">대여료</td>			
            <td class='title' width="12%">과태료</td>						
            <td class='title' width="12%">면책금</td>									
            <td class='title' width="12%">중도해지위약금</td>												
            <td class='title' width="12%">합계</td>
          </tr>
		  <%	for (int i = 0 ; i < settle_size ; i++){
					Hashtable settle = (Hashtable)settles.elementAt(i);%>
          <tr> 
		    <input type='hidden' name='c_id_<%=i%>' value='<%=settle.get("CAR_MNG_ID")%>'>
		    <input type='hidden' name='m_id_<%=i%>' value='<%=settle.get("RENT_MNG_ID")%>'>
            <td align='center' width="4%" ><input type="checkbox" name="ch_l_cd_<%=i%>" value="Y" checked></td>
            <td align='center' width="14%"><input type="text" name="l_cd_<%=i%>" size="15" class="whitetext" value="<%=settle.get("RENT_L_CD")%>"></td>
            <td align='center' width="12%"><input type="text" name="car_no_<%=i%>" size="11" class="whitetext" value="<%=settle.get("CAR_NO")%>"></td>
            <td align='center' width="12%"><input type="text" name="amt1_<%=i%>" size="10" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT1")))%>"></td>
            <td align='center' width="12%"><input type="text" name="amt2_<%=i%>" size="10" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT2")))%>"></td>			
            <td align='center' width="10%"><input type="text" name="amt3_<%=i%>" size="8" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT3")))%>"></td>						
            <td align='center' width="10%"><input type="text" name="amt4_<%=i%>" size="8" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT4")))%>"></td>									
            <td align='center' width="12%"><input type="text" name="amt5_<%=i%>" size="10" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT6")))%>"></td>												
            <td align='center' width="14%"><input type="text" name="amt6_<%=i%>" size="11" class="whitenum" value="<%=Util.parseDecimal(String.valueOf(settle.get("EST_AMT0")))%>"></td>
          </tr>
		  <%	}%>
        </table>
	  </td>
    </tr>	
    <tr>
        <td></td>
    </tR>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>세금계산서 발행 일시중지 등록</span></td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tR>	
    <tr>
	    <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr>
            <td width=12% class='title'>계산서발행</td>
            <td>&nbsp;
              <input type="checkbox" name="tax_yn" value="Y">
              중지
            </td>
          </tr>
          <tr>
            <td class='title'>구분</td>
            <td>&nbsp;
              <input type="radio" name="stop_st" value="1" >
              연체
            </td>
          </tr>
          <tr>
            <td class='title'>중지기간</td>
            <td><table width="300"  border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td width="115">&nbsp;
				<input type='text' name='stop_s_dt' value='' maxlength='12' size='12' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  부터</td>
                <td width="115"><input type='text' name='stop_e_dt' value='' maxlength='12' size='12' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
                  까지</td>
                <td></td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td class='title'>사유</td>
            <td>&nbsp;
              <textarea name="stop_cau" cols="75" rows="3" class="text"></textarea>
            </td>
          </tr>
        </table>
      </td>
    </tr>	
	<%}%>	
    <tr>
      <td align="right">
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>	
	  <a href='javascript:doc_reg()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
	  <%}%>
	  </td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
