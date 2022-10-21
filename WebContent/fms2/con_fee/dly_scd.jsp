<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*"%>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(gubun)
	{
		var fm = document.form1;
		if(gubun == 'i'){
			if(fm.seq.value != ''){	alert("이미 등록된 스케줄입니다."); return; }
//			if(fm.s_s.value == '' || fm.s_s.value == '0'){ alert("수금할 연체료가 없습니다."); return; }
//			if(toInt(parseDigit(fm.s_s.value)) < toInt(parseDigit(fm.pay_amt.value))){ alert("수금할 연체료보다 더 큰 금액입니다. 확인하십시오."); return; }
		}else{
			if(fm.seq.value == ''){	alert("등록되지 않은 스케줄입니다."); return; }		
		}
		if(fm.pay_dt.value == ''){ alert("입금일자를 입력하십시오"); return; }
		if(fm.pay_amt.value == ''){ alert("입금액을 입력하십시오"); return; }		
		fm.gubun.value = gubun;
		fm.action = 'dly_scd_a.jsp';		
		fm.target = 'i_no';
		fm.submit();
	}
	
	//연체료 통계 셋팅
	function set_stat_amt(){
		var fm = document.form1;
		fm.s_s.value = parseDecimal(toInt(parseDigit(fm.s_n.value)) - toInt(parseDigit(fm.s_v.value)));		
	}
	
	//연체료 등록,수정
	function set_dly(rent_l_cd, seq, pay_dt, pay_amt, etc){
		var fm = document.form1;
		fm.rent_l_cd.value = rent_l_cd;
		fm.seq.value = seq;
		fm.pay_dt.value = pay_dt;
		fm.pay_amt.value = pay_amt;
		fm.etc.value = etc;		
	}

	//닫기..
	function dly_close()
	{
		var fm = document.form1;
		fm.action = 'fee_c_mgr.jsp';
		fm.target = 'd_content';		
		fm.submit();
		window.close();		
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onload="javascript:document.form1.pay_dt.focus();">
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String idx = request.getParameter("idx")==null?"0":request.getParameter("idx");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	//기본정보
	Hashtable fee = af_db.getFeebaseNew(m_id, l_cd);
	
	//연체료 수금 스케줄 통계
	Hashtable fee_stat = af_db.getFeeScdStatPrint2(m_id, l_cd);
	int fee_stat_size = fee_stat.size();
	
	//연체료 수금 스케줄 리스트
	Vector fee_scd = af_db.getFeeDlyScd(m_id, l_cd);
	int fee_scd_size = fee_scd.size();
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "01", "02");
	
	long total_amt 	= 0;
%>
<form name='form1' action='' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
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
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='gubun' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>연체료 수금관리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr> 
    <tr> 
        <td class=line2></td>
    </tr>  	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>                     
                    <td class='title' width=14%>상호</td>
                    <td align='center' width=54%><%=fee.get("FIRM_NM")%></td>
                    <td class='title' width=12%>차량번호</td>
                    <td align='center' width=20%><%=fee.get("CAR_NO")%></td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr> 
        <td class=h></td>
    </tr> 
    <tr> 
        <td class=line2></td>
    </tr>  	
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width=14%>수금연체료</td>
                    <td align='center' width=20%> 
                      <input type='text' name='s_v' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("DT2")))%>' size='9' class='whitenum' >
                      원&nbsp;</td>
                    <td class='title' width=14%>미수연체료</td>
                    <td align='center' width=20%> 
                      <input type='text' name='s_s' value='' size='9' class='whitenum' >
                      원&nbsp;</td>
                    <td class='title' width=12%>총연체료</td>
                    <td align='center' width=20%> 
                      <input type='text' name='s_n' value='<%=Util.parseDecimal(String.valueOf(fee_stat.get("DT")))%>' size='9' class='whitenum' >
                      원&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align='left'></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>   
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title' width='14%'> 연번</td>				
                    <td class='title' width="20%">입금일자</td>
                    <td class='title' width='20%'>입금액</td>
                    <td class='title'>비고</td>
                </tr>
    		    <%for(int i = 0 ; i < fee_scd_size ; i++){
    				FeeDlyScdBean a_fee = (FeeDlyScdBean)fee_scd.elementAt(i);%>				  
                <tr> 
                    <td align="center"><%=i+1%></td>                    				
                    <td align="center"><a href="javascript:set_dly('<%=a_fee.getRent_l_cd()%>','<%=a_fee.getSeq()%>','<%=a_fee.getPay_dt()%>','<%=Util.parseDecimal(a_fee.getPay_amt())%>','<%=a_fee.getEtc()%>')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><%=a_fee.getPay_dt()%></a></td>
                    <td align="center"> 
                      <input type='text' name='amt' value='<%=Util.parseDecimal(a_fee.getPay_amt())%>' size='8' class='whitenum'>원</td>
                    <td>&nbsp;<%=a_fee.getEtc()%></td>
                </tr>
    		    <%		total_amt 	= total_amt + Long.parseLong(String.valueOf(a_fee.getPay_amt()));
					}%>		
                <tr> 
                    <td class="title" colspan="2">합계</td>
                    <td class="title"><input type='text' name='total_amt' value='<%=Util.parseDecimal(total_amt)%>' size='8' class='whitenum'>원</td>
                    <td class="title">&nbsp;</td>
                </tr>	
            </table>
        </td>
    </tr>    
               <tr> 
        <td class=h></td>
    </tr> 
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                				  
                <tr> 
                    <td width='14%' align="center"><input type='text' name='seq' size='1' value='' class='whitetext'><input type='hidden' name='rent_l_cd' value=''></td>					
                    <td width='20%' align="center"> 
                      <input type='text' name='pay_dt' size='12' class='text' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td width='20%' align="center"> 
                      <input type='text' name='pay_amt' size='8' class='num'>원</td>
                    <td>&nbsp;
                      <input type='text' name='etc' size='35' class='text' style='IME-MODE: active'>
                      
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td align='right'>
	    <%if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>				  
	     <a href="javascript:save('i')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a> 
        &nbsp;<a href="javascript:save('u')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_modify.gif"  align="absmiddle" border="0"></a> 
	    <%}%>	
        &nbsp;<a href="javascript:dly_close()" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src="/acar/images/center/button_close.gif"  align="absmiddle" border="0"></a></td>
    </tr>
</table>
<script language='javascript'>
<!--
	set_stat_amt();
-->
</script>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>  
</body>
</html>