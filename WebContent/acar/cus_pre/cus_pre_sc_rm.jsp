<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.cus_pre.*, acar.user_mng.*, acar.condition.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CusPre_Database cp_db = CusPre_Database.getInstance();
	ConditionDatabase cdb = ConditionDatabase.getInstance();
	
	String user_nm = request.getParameter("user_nm")==null?"":request.getParameter("user_nm");
	Hashtable id = c_db.getDamdang_id(user_nm);
	user_id = String.valueOf(id.get("USER_ID"));
	
	//(구)월렌트 계약개시
	Vector conts3 = cp_db.getRentMonContList(br_id, user_id, "1");

	//(구)월렌트 만료예정
	Vector conts4 = cp_db.getRentMonContList(br_id, user_id, "2");

	//(구)월렌트 미수금스케줄
	Vector conts5 = cp_db.getRentMonSettleList(br_id, user_id, "2");

	//(신)월렌트 계약개시
	Vector conts3_2 = cp_db.getRmRentMonContList(br_id, user_id, "1");

	//(신)월렌트 만료예정
	Vector conts4_2 = cp_db.getRmRentMonContList(br_id, user_id, "2");

	//(신)월렌트 미수금스케줄
	Vector conts5_2 = cp_db.getRmRentMonSettleList(br_id, user_id, "2");

	
	
	//로그인ID&영업소ID&권한
	String acar_id = ck_acar_id;
%>
<%	%>
<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
	//새로고침
	function CusPreRmRelode(){
		var fm = document.form1;
		fm.action = 'cus_pre_sc_rm.jsp';		
		fm.submit();					
	}	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}
		
	//월렌트 계약서 내용 보기
	function view_cont_res(s_cd, c_id){
	
		var fm = document.form1;		
		fm.action = '/acar/rent_mng/res_rent_u.jsp?mode=c&s_cd='+s_cd+'&c_id='+c_id;				
		fm.target = 'd_content';
		fm.submit();
	}	

	//월렌트 계약서 내용 보기-연장등록가능하게
	function view_cont_res2(s_cd, c_id){
	
		var fm = document.form1;		
		fm.action = '/acar/rent_mng/res_rent_u.jsp?end_est_yn=Y&mode=c&s_cd='+s_cd+'&c_id='+c_id;				
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//월렌트 통화내용 보기
	function RentMemo(s_cd, c_id, user_id){
		var SUBWIN="/acar/con_rent/res_memo_i.jsp?s_cd="+s_cd+"&c_id="+c_id+"&user_id="+user_id;	
		window.open(SUBWIN, "RentMemoDisp", "left=100, top=100, width=580, height=700, scrollbars=yes");
	}	
	
	//대여료메모
	function view_memo(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");						
	}		
			
 	//계약서 내용 보기
	function view_cont(m_id, l_cd){
		var fm = document.form1;
		fm.rent_mng_id.value = m_id;
		fm.rent_l_cd.value = l_cd;
		fm.target = 'd_content';		
		fm.action = '/fms2/lc_rent/lc_c_frame.jsp';			
		fm.submit();
	}	
//-->
</script>
</head>

<body><a name="top"></a>
<form name='form1' method='post' action=''>
<input type='hidden' name='rent_mng_id' value=''>
<input type='hidden' name='rent_l_cd' value=''>
<input type='hidden' name='gubun1' value=''>
<input type='hidden' name='gubun2' value=''>
<input type='hidden' name='gubun3' value=''>
<input type='hidden' name='t_wd' value=''>
<table width="100%" border="0" cellspacing="0" cellpadding="0">	
    <tr> 
        <td><a name='5'></a></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>월렌트 신규계약개시 (D+10일) : 총 <font color="#FF0000"><%= conts3.size() %></font>건</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td width="100%" class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=3% class='title'>연번</td>
                    <td width=20% class='title'>상호</td>
                    <td width=10% class='title'>차량번호</td>
                    <td width=15% class='title'>차종</td>
                    <td width=17% class='title'>대여개시일</td>                    
                    <td width=15% class='title'>대여개월</td>
                    <td width=10% class='title'>최초영업</td>                    
                    <td width=10% class='title'>관리담당</td>
                </tr>
          <%if(conts3.size()+conts3_2.size() > 0){%>
          <%		for(int i = 0 ; i < conts3.size() ; i++){
					Hashtable ht = (Hashtable)conts3.elementAt(i); %>
                <tr> 
                    <td align='center'><%= i+1 %></td>
                    <td align='center'><a href="javascript:view_cont_res('<%=ht.get("RENT_S_CD")%>','<%=ht.get("CAR_MNG_ID")%>')"><%=ht.get("FIRM_NM")%></a></td>
                    <td align='center'><%=ht.get("CAR_NO")%></td>
                    <td align='center'><%=ht.get("CAR_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("DELI_DT")))%></td>
                    <td align='center'><%=ht.get("RENT_MONTHS")%>개월<%=ht.get("RENT_DAYS")%>일</td>
                    <td align="center"><%=ht.get("BUS_NM")%></td>
                    <td align="center"><%=ht.get("MNG_NM")%></td>
                </tr>
          <% 		}%>
          <%		for(int i = 0 ; i < conts3_2.size() ; i++){
					Hashtable ht = (Hashtable)conts3_2.elementAt(i); %>
                <tr> 
                    <td align='center'><%= conts3.size()+i+1 %></td>
                    <td align='center'><a href="javascript:view_cont('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')"><%=ht.get("FIRM_NM")%></a></td>
                    <td align='center'><%=ht.get("CAR_NO")%></td>
                    <td align='center'><%=ht.get("CAR_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("RENT_START_DT")))%></td>
                    <td align='center'><%=ht.get("CON_MON")%>개월<%=ht.get("CON_DAY")%>일</td>
                    <td align="center"><%=ht.get("BUS_NM")%></td>
                    <td align="center"><%=ht.get("MNG_NM")%></td>
                </tr>
          <% 		}%>
	  <%	  }else{ %>
                <tr> 
                    <td colspan="10" align='center'>해당하는 신규 계약건이 없습니다.</td>
                </tr>
          <%}%>
             </table>
        </td>
    </tr>
    <tr> 
        <td><a name='6'></a></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>월렌트 계약만료예정 (D-10일) : 총 <font color="#FF0000"><%= conts4.size() %></font>건</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=3% class='title'>연번</td>
                    <td width=20% class='title'>상호</td>
                    <td width=10% class='title'>차량번호</td>
                    <td width=15% class='title'>차종</td>
                    <td width=17% class='title'>만료예정일</td>                    
                    <td width=15% class='title'>대여개월</td>
                    <td width=10% class='title'>최초영업</td>                    
                    <td width=10% class='title'>관리담당</td>
                </tr>
          <%if(conts4.size()+conts4_2.size() > 0){%>
          
          <%		for(int i = 0 ; i < conts4.size() ; i++){
					Hashtable ht = (Hashtable)conts4.elementAt(i);
					%>
                <tr> 
                    <td align='center'><a href="javascript:RentMemo('<%=ht.get("RENT_S_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ck_acar_id%>')"><%= i+1 %></a></td>
                    <td align='center'><a href="javascript:view_cont_res2('<%=ht.get("RENT_S_CD")%>','<%=ht.get("CAR_MNG_ID")%>')"><%=ht.get("FIRM_NM")%></a></td>
                    <td align='center'><%=ht.get("CAR_NO")%></td>
                    <td align='center'><%=ht.get("CAR_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("RET_PLAN_DT")))%></td>
                    <td align='center'><%=ht.get("RENT_MONTHS")%>개월<%=ht.get("RENT_DAYS")%>일</td>
                    <td align="center"><%=ht.get("BUS_NM")%></td>
                    <td align="center"><%=ht.get("MNG_NM")%></td>
                </tr>
          <% 		}%>
          
          <%		for(int i = 0 ; i < conts4_2.size() ; i++){
					Hashtable ht = (Hashtable)conts4_2.elementAt(i);
					%>
                <tr> 
                    <td align='center'><a href="javascript:view_memo('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')"><%= conts4.size()+i+1 %></a></td>
                    <td align='center'><a href="javascript:view_cont('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')"><%=ht.get("FIRM_NM")%></a></td>
                    <td align='center'><%=ht.get("CAR_NO")%></td>
                    <td align='center'><%=ht.get("CAR_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ht.get("RENT_END_DT")))%></td>
                    <td align='center'><%=ht.get("CON_MON")%>개월<%=ht.get("CON_DAY")%>일</td>
                    <td align="center"><%=ht.get("BUS_NM")%></td>
                    <td align="center"><%=ht.get("MNG_NM")%></td>
                </tr>
          <% 		}%>          
          
	  <%	  }else{ %>
                <tr> 
                    <td colspan="13" align='center'>해당하는 만료 계약건이 없습니다.</td>
                </tr>
          <% } %>
            </table>
        </td>
    </tr>
    <tr> 
        <td><a name='7'></a></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>월렌트 미수금스케줄 (D-10일) : 총 <font color="#FF0000"><%= conts5.size() %></font>건</span></td>
    </tr>
    <tr>    
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=3% class='title'>연번</td>
                    <td width=19% class='title'>상호</td>
                    <td width=8% class='title'>차량번호</td>                
                    <td width=5% class='title'>상태</td>
                    <td width=15% class='title'>대여기간</td>                        
                    <td width=8% class='title'>구분</td>
                    <td width=8% class='title'>수금방식</td>
                    <td width=10% class='title'>입금예정일</td>
                    <td width=8% class='title'>금액</td>
                    <td width=8% class='title'>최초영업</td>                    
                    <td width=8% class='title'>관리담당</td>
                </tr>
          <%if(conts5.size()+conts5_2.size() > 0){%>
          
          <%		for(int i = 0 ; i < conts5.size() ; i++){
					Hashtable ht = (Hashtable)conts5.elementAt(i);
					%>
                <tr> 
                    <td align='center'><a href="javascript:RentMemo('<%=ht.get("RENT_S_CD")%>','<%=ht.get("CAR_MNG_ID")%>','<%=ck_acar_id%>')"><%= i+1 %></a></td>
                    <td align='center'><a href="javascript:view_cont_res('<%=ht.get("RENT_S_CD")%>','<%=ht.get("CAR_MNG_ID")%>')"><%=ht.get("FIRM_NM")%></a></td>
                    <td align='center'><%=ht.get("CAR_NO")%></td>
                    <td align='center'><%=ht.get("USE_ST_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("END_DT")))%></td>
                    <td align="center"><%=ht.get("SCD_RENT_ST_NM")%></td>
                    <td align="center"><%=ht.get("SCD_PAID_ST_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("RENT_AMT")))%></td>
                    <td align="center"><%=ht.get("BUS_NM")%></td>
                    <td align="center"><%=ht.get("MNG_NM")%></td>
                </tr>
          <% 		}%>
          
          <%		for(int i = 0 ; i < conts5_2.size() ; i++){
					Hashtable ht = (Hashtable)conts5_2.elementAt(i);
					%>
                <tr> 
                    <td align='center'><a href="javascript:view_memo('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')"><%= conts5.size()+i+1 %></a></td>
                    <td align='center'><a href="javascript:view_cont('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>')"><%=ht.get("FIRM_NM")%></a></td>
                    <td align='center'><%=ht.get("CAR_NO")%></td>
                    <td align='center'><%=ht.get("USE_ST_NM")%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
                    <td align="center"><%=ht.get("SCD_RENT_ST_NM")%>대여료</td>
                    <td align="center"><%if(!String.valueOf(ht.get("CMS_START_DT")).equals("") && !String.valueOf(ht.get("CMS_REG_ST")).equals("2")){%>자동이체<%}else{%>-<%}%></td>
                    <td align='center'><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align='right'><%=Util.parseDecimal(String.valueOf(ht.get("RENT_AMT")))%></td>
                    <td align="center"><%=ht.get("BUS_NM")%></td>
                    <td align="center"><%=ht.get("MNG_NM")%></td>
                </tr>
          <% 		}%>          
          
	  <%	  }else{ %>
                <tr> 
                    <td colspan="11" align='center'>해당하는 스케줄이 없습니다.</td>
                </tr>
          <% } %>
            </table>
        </td>
    </tr>    
    	    
</table>
</form>
</body>
</html>

