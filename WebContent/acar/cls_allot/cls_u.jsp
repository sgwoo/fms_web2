<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.debt.*, acar.cls.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//등록하기
	function save(){
		var fm = document.form1;
		if(fm.cls_rtn_dt.value == ''){ alert('해지일자를 입력하십시오'); fm.cls_rtn_dt.focus(); return;	}
		else if(fm.cls_rtn_cau.value == ''){ alert('해지내역를 입력하십시오'); fm.cls_rtn_cau.focus(); return; }
		else if(fm.nalt_rest.value == ''){ alert('미상환원금을 입력하십시오');	fm.nalt_rest.focus(); return; }
		else if(fm.cls_rtn_amt.value == ''){ alert('중도해지금액를 확인하십시오'); fm.cls_rtn_amt.focus(); return; }			
		if(!confirm('수정하시겠습니까?'))
			return;
		fm.target='i_no';
		fm.action='cls_u_a.jsp';
		fm.submit();		
	}

	//입력시 자동 계산하기	
	function set_cls_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		fm.cls_rtn_amt.value = parseDecimal(toInt(parseDigit(fm.nalt_rest.value)) + toInt(parseDigit(fm.cls_rtn_fee.value)) + toInt(parseDigit(fm.cls_etc_fee.value)) + toInt(parseDigit(fm.cls_rtn_int_amt.value)) + toInt(parseDigit(fm.dly_alt.value)) - toInt(parseDigit(fm.be_alt.value)));			
	}
//-->
</script>
</head>
<body onload="javascript:document.form1.cls_rtn_cau.focus();">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "02");

	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] banks = c_db.getBankList("1"); /* 코드 구분:제1금융권 */	
	int bank_size = banks.length;
	
	Hashtable allot = ad_db.getAllotClsinfo(m_id, l_cd, car_id);
	
	ClsAllotBean cls = as_db.getClsAllot(m_id, l_cd);
%>
<form name='form1' method='post' action='cls_u_a.jsp'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr> 
      <td colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td align='left'><font color="navy">계약관리 -> 할부금관리</font> -> <font color="red">할부금 
              중도해지</font></td>
            <td align='right'><%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%><a href='javascript:save();' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0" alt="수정"></a><%}%> 
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td width='90' class='title'>계약번호</td>
            <td width='110'>&nbsp;<%=l_cd%></td>
            <td width='80' class='title'>상호</td>
            <td width='130'>&nbsp;<%=allot.get("FIRM_NM")%></td>
            <td width='80' class='title'>대여차명</td>
            <td width="110">&nbsp;<%=allot.get("CAR_NM")%></td>
            <td class='title' width="80">차량번호</td>
            <td>&nbsp;<%=allot.get("CAR_NO")%></td>
          </tr>
          <tr> 
            <td class='title' width="90">금융사</td>
            <td width="110">&nbsp;<%=c_db.getNameById((String)allot.get("CPT_CD"), "BANK")%></td>
            <td class='title' width="80">대출번호</td>
            <td width="130">&nbsp;<%=allot.get("LEND_NO")%></td>
            <td class='title' width="80">대출일자</td>
            <td width="130">&nbsp;<%=allot.get("LEND_DT")%></td>
            <td class='title' width="80">최초취득원가</td>
            <td width="110" align="right">&nbsp;<%=AddUtil.parseDecimal(AddUtil.parseInt((String)allot.get("LEND_PRN")))%>&nbsp;원&nbsp;&nbsp;</td>
          </tr>
          <tr> 
            <td class='title' width="90">이자율</td>
            <td width="110">&nbsp;<%=allot.get("LEND_INT")%>%</td>
            <td class='title' width="80">미상환원금</td>
            <td align='right'>&nbsp;<%=AddUtil.parseDecimal(cls.getNalt_rest())%>&nbsp;원&nbsp;&nbsp;</td>
            <td class='title' width="80">최종수납일</td>
            <td width="130" colspan='3'>&nbsp;<%=cls.getMax_pay_dt()%></td>
          </tr>
			    <tr>
    				<td class='title'>중도상환<br>수수료</td>
    		 		<td>&nbsp;<%=allot.get("CLS_RTN_FEE_INT")%>%&nbsp;</td>
    				<td class='title'>중도상환<br>특이사항</td>
    				<td colspan='5'>&nbsp;<%=allot.get("CLS_RTN_ETC")%></td>
			    </tr>							  
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">&lt;&lt;중도해지금액 산출내역&gt;&gt;</td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width="800">
                <tr> 
                    <td class='title'>해지일자</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_rtn_dt' size='12' class='text' onBlur='javascript: this.value = ChangeDate(this.value)' value='<%=cls.getCls_rtn_dt()%>'></td>
                </tr>		
                <tr> 
                    <td class='title'>해지내역 </td>
                    <td> &nbsp; 
                      <textarea name='cls_rtn_cau' rows='2' cols='100' style='IME-MODE: active'><%=cls.getCls_rtn_cau()%></textarea>
                    </td>
                </tr>							
          <tr> 
            <td width='90' class='title'> 미상환원금</td>
            <td>&nbsp; 
              <input type='text' name='nalt_rest' size='15' value='<%=AddUtil.parseDecimal(cls.getNalt_rest())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
              원&nbsp;&nbsp;
					  (유동성장기부채 :
                      <input type='text' name='nalt_rest_1' size='15' value='<%=AddUtil.parseDecimal(cls.getNalt_rest_1())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                      원, &nbsp;&nbsp;장기차입금 :
                      <input type='text' name='nalt_rest_2' size='15' value='<%=AddUtil.parseDecimal(cls.getNalt_rest_2())%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); '>
                      원&nbsp;&nbsp;)</td>
          </tr>
          <tr> 
            <td class='title' width="90">중도해지수수료</td>
            <td>&nbsp; 
              <input type='text' name='cls_rtn_fee' value='<%=AddUtil.parseDecimal(cls.getCls_rtn_fee())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
              원 
              <input type='text' size='4' name='cls_rtn_fee_int' value='<%=cls.getCls_rtn_fee_int()%>' class='num' onBlur='javascript:set_cls_amt(this)' maxlength='4'>
              % </td>
          </tr>
          <tr> 
            <td width='90' class='title'> 경과이자</td>
            <td>&nbsp; 
              <input type='text' name='cls_rtn_int_amt' value='<%=AddUtil.parseDecimal(cls.getCls_rtn_int_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
              원&nbsp;</td>
          </tr>
          <tr> 
                    <td class='title'> 기타수수료</td>
                    <td>&nbsp; 
                      <input type='text' name='cls_etc_fee' value='<%=AddUtil.parseDecimal(cls.getCls_etc_fee())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
                      원&nbsp;(저당말소대행비 등)</td>
                </tr>       
          <tr> 
            <td width='90' class='title'> 연체할부금</td>
            <td>&nbsp; 
              <input type='text' name='dly_alt' value='<%=AddUtil.parseDecimal(cls.getDly_alt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
              원&nbsp;</td>
          </tr>
          <tr> 
            <td width='90' class='title'> 선수금</td>
            <td>&nbsp; 
              <input type='text' name='be_alt' value='<%=AddUtil.parseDecimal(cls.getBe_alt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_cls_amt(this);'>
              원&nbsp;</td>
          </tr>
          <tr> 
            <td width='90' class='title'> 합계</td>
            <td>&nbsp; 
              <input type='text' name='cls_rtn_amt' value='<%=AddUtil.parseDecimal(cls.getCls_rtn_amt())%>' size='15' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
              원&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align=''left> <<납입은행>> </td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=800>
          <tr> 
            <td width='90' class='title'> 은행명</td>
            <td width='110'>&nbsp; 
			  <input type="text" size="10" name="bk_code" value='<%=cls.getBk_code()%>' class="text">
			  <!--
              <select name='bk_code'>
			    <option value=''>선택</option>
                <%	if(bank_size > 0){
								for(int i = 0 ; i < bank_size ; i++){
									CodeBean bank = banks[i];		%>
                <option value='<%= bank.getCode()%>' <%if(cls.getBk_code().equals(bank.getCode()))%>selected<%%>><%= bank.getNm()%></option>
                      <%		}
							}		%>
                    </select>-->
            </td>
            <td width='80' class='title'> 계좌번호</td>
            <td width="230">&nbsp; 
              <input type="text" size="30" name="acnt_no" value='<%=cls.getAcnt_no()%>' class="text">
            </td>
            <td class='title' width="80">예금주명</td>
            <td>&nbsp; 
              <input type='text' size='20' name='acnt_user' value='<%=cls.getAcnt_user()%>' class='text'>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr align="right"> 
      <td> <a href='javascript:window.close();' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0" alt="닫기"></a></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="100" height="50" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>
