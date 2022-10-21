<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.settle_acc.*"%>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String bus_id2 = request.getParameter("bus_id2")==null?"":request.getParameter("bus_id2");
	long r_dly_amt = request.getParameter("r_dly_amt")==null?0:Long.parseLong(request.getParameter("r_dly_amt"));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector vt = s_db.getStatSettleSubList3Gun(bus_id2);
	int vt_size = vt.size();
	
		
	long total_amt 	= 0;
	
%>

<html>
<head>
	<title>Untitled</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">	
<link rel=stylesheet type="text/css" href="/include/table_t.css">	
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//계약정보 보기
	function view_client(m_id, l_cd)
	{
		window.open("/agent/con_fee/con_fee_client_s.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "VIEW_CLIENT", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}	

	function view_scd(m_id, l_cd){
		window.open("/fms2/con_fee/fee_scd_print.jsp?m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "VIEW_SCD", "left=100, top=100, width=820, height=700, scrollbars=yes");
	}	
	
	//대여료메모
	function view_memo(m_id, l_cd)
	{
		//단기대여(월렌트)
		if(m_id == '' && l_cd.length ==6){
			
		//장기대여
		}else{
			window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=2&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");
		}
	}
//-->	
</script>		
</head>

<body>

<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value=''>
<input type='hidden' name='br_id' value=''>
<input type='hidden' name='user_id' value=''>
<input type='hidden' name='size' value='8'>
<input type='hidden' name='m_id' value=''>
<input type='hidden' name='l_cd' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 캠페인관리 > <span class=style5><%=c_db.getNameById(bus_id2,"CAR_OFF_EMP")%> 채권리스트 </span></span></td>
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
        <td  class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=3% class='title'>연번</td>
                    <td width=10% class='title'>계약번호</td>
                    <td width=15% class='title'>상호</td>
                    <td width=8% class='title'>차량번호</td>
                    <td width=11% class='title'>차명</td>					
                    <td width=7% class='title'>항목</td>
                    <td width=8% class='title'>구분</td>
                    <td width=8% class='title'>입금예정일</td>
                    <td width=7% class='title'>연체금액</td>		    
		    <td width=8% class='title'>납부약속일</td>		    
		    <td width=4% class='title'>통화</td>		    
                </tr>		
<%
	//대여료리스트
	if(vt_size > 0){
		for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>				  
                <tr> 
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=i+1%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><a href="javascript:view_client('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" title=""><%=ht.get("RENT_L_CD")%></a></td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=ht.get("FIRM_NM")%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=ht.get("CAR_NO")%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=ht.get("CAR_NM")%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>>
                      <%if(String.valueOf(ht.get("GUBUN1")).equals("대여료")||String.valueOf(ht.get("GUBUN1")).equals("연체이자")){%>
					            <a href="javascript:view_scd('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')"><%=ht.get("GUBUN1")%></a>
					            <%}else{%>
					            <%=ht.get("GUBUN1")%>
					            <%}%>
                    </td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=ht.get("GUBUN2")%><br><%=ht.get("USER_NM")%></td>
                    <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>					
                    <td align="right"  <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%></td>		
		                <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><%=AddUtil.ChangeDate2(String.valueOf(ht.get("PROMISE_DT")))%></td>
		                <td align="center" <%if(!String.valueOf(ht.get("USE_YN")).equals("Y"))%>class='is'<%%>><a href="javascript:view_memo('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>');" title="">보기</a></td>
                </tr>
<%			total_amt 	= total_amt + Long.parseLong(String.valueOf(ht.get("DLY_AMT")));
		}
		%>		
                <tr> 
                    <td class="title" colspan="8" >합계 </td>
		    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>
		    <td class="title">&nbsp;</td>
		    <td class="title">&nbsp;</td>
                </tr>		
<%	} %>		 
            </table>
        </td>
    </tr>
    <tr> 
        <td height="22"">&nbsp;&nbsp;    
            ※ 채권캠페인의 연체금액은 마감한 값이고, 이 리스트는 실시간입니다.
        </td>
    </tr>    
</table>
</form>
</body>
</html>
