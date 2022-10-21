<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.ext.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	if(s_kd.equals("4")){
		t_wd = AddUtil.replace(t_wd,"-","");
	}

	if(!gubun3.equals("")){
		gubun3 = AddUtil.replace(gubun3,"-","");
	}

	Vector vt = ae_db.getScdPpCostBaseStat(s_kd, t_wd, gubun1, gubun2, gubun3);
	int vt_size = vt.size();	
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function Search(){
		var fm = document.form1;		
		fm.action = "scd_pp_cost_base_sc.jsp";
		fm.target = "_self";
		fm.submit();
	}

	function CostCase(rent_mng_id, rent_l_cd, rent_st, gubun2){
		var fm = document.form1;
		fm.rent_mng_id.value = rent_mng_id;
		fm.rent_l_cd.value = rent_l_cd;
		fm.rent_st.value = rent_st;
		fm.r_gubun2.value = gubun2;
		fm.target = "c_foot";
		fm.action = "scd_pp_cost_case_sc.jsp";
		fm.submit();		
	}
	
	
	
	function Pp_Autodocu(){
		fm = document.form1;
		
		if(fm.auto_dt.value == ''){ alert('전표일자를 입력하십시오.'); return;}
		
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
		 	alert("일괄 처리할 건을 선택하세요.");
			return;
		}	
				
		if(!confirm("등록하시겠습니까?"))	return;
		//fm.action = 'scd_pp_cost_base_sc_auto_a.jsp';
		//fm.target = '_blank';
		//fm.submit();	
	}
//-->
</script>
</head>
<body>
<form name='form1' action='scd_pp_cost_base_sc.jsp' method='post' target='c_foot'>
<input type='hidden' name='rent_mng_id' value=''>
<input type='hidden' name='rent_l_cd' value=''>
<input type='hidden' name='rent_st' value=''>
<input type='hidden' name='r_gubun2' value=''>
<input type='hidden' name='go_url' value='/fms2/scd_pp_cost/scd_pp_cost_base_sc.jsp'>

  <table border="0" cellspacing="0" cellpadding="0" width=1600>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선수대여료 관리</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='220'  class='title'>검색</td>
            <td>&nbsp;
              <select name="s_kd" id="s_kd">               
                <option value='1' <%if(s_kd.equals("1")){%> selected <%}%>>차량번호</option>
                <option value='2' <%if(s_kd.equals("2")){%> selected <%}%>>상호</option>
                <option value='3' <%if(s_kd.equals("3")){%> selected <%}%>>계약번호</option>
                <option value='4' <%if(s_kd.equals("4")){%> selected <%}%>>개시일자</option>
                <option value='5' <%if(s_kd.equals("5")){%> selected <%}%>>계약관리번호</option>
              </select>
              <input type='text' name='t_wd' size='22' class='text' value='<%=t_wd%>' style='IME-MODE: active'>
              &nbsp;&nbsp;&nbsp;
                        진행구분 : 
              <select name="gubun1" id="gubun1">               
                <option value=''  <%if(gubun1.equals("")){%> selected <%}%>>전체</option>
                <option value='Y' <%if(gubun1.equals("Y")){%> selected <%}%>>진행</option>
                <option value='N' <%if(gubun1.equals("N")){%> selected <%}%>>해지</option>
              </select>
              &nbsp;
                        구분 : 
              <select name="gubun2" id="gubun2">               
                <option value=''  <%if(gubun2.equals("")){%> selected <%}%>>전체</option>
                <option value='1' <%if(gubun2.equals("1")){%> selected <%}%>>선납금</option>
                <option value='2' <%if(gubun2.equals("2")){%> selected <%}%>>개시대여료</option>
                <option value='3' <%if(gubun2.equals("3")){%> selected <%}%>>대여료</option>
              </select>
              &nbsp;
                        수익반영 기준일자 : 
              <input type='text' name='gubun3' size='13' class='text' value='<%=gubun3%>' style='IME-MODE: active'>                         
              &nbsp;                           
              &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
            </td>
          </tr>
        </table>
      </td>
    </tr> 
    <tr> 
        <td class=h></td>
    </tr>	  
    <tr>
	    <td align="right">(공급가기준)</td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    
                    <td width='50' rowspan='3' class='title'>연번</td>
                    <td width='50' rowspan='3' class='title'>진행</td>
                    <td width='120' rowspan='3' class='title'>계약번호</td>
                    <td width='210' rowspan='3' class='title'>계약자<br>(상호/성명)</td>
                    <td width='100' rowspan='3' class='title'>차량번호</td>
                    <td colspan='3' class='title'>계약기간</td>
                    <td colspan='5' class='title'>선수대여료</td>
                    <td colspan='2' class='title'>수익반영현황</td>
                    <td colspan='2' class='title'>해지현황</td>
                </tr>
                <tr>
                    <td width='90' rowspan='2' class='title'>개시일자</td>
                    <td width='90' rowspan='2' class='title'>종료일자</td>
                    <td width='50' rowspan='2' class='title'>계약<br>개월수</td>
                    <td colspan='3' class='title'>입금내역</td>
                    <td colspan='2' class='title'>수익반영기간</td>
                    <td width='90' rowspan='2' class='title'>실행금액</td>
                    <td width='90' rowspan='2' class='title'>잔액</td>
                    <td width='60' rowspan='2' class='title'>구분</td>
                    <td width='90' rowspan='2' class='title'>종료일자</td>
                </tr>
                <tr>

                    <td width='100' class='title'>구분</td>
                    <td width='90' class='title'>금액</td>
                    <td width='90' class='title'>입금일자</td>
                    <td width='90' class='title'>개일일자</td>
                    <td width='90' class='title'>종료일자</td>
                </tr>                
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            
					            total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("F_REST_AMT")));
								total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("RC_AMT")));
								total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("REST_AMT")));
					      %>
                <tr>
                    
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("GUBUN")%></td>
                    <td align="center"><a href="javascript:CostCase('<%=ht.get("RENT_MNG_ID")%>','<%=ht.get("RENT_L_CD")%>','<%=ht.get("RENT_ST")%>','<%=ht.get("GUBUN2")%>')" onMouseOver="window.status=''; return true"><%=ht.get("RENT_L_CD")%></a></td>
                    <td align="center"><span title='<%=ht.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(ht.get("FIRM_NM")), 15)%></span></td>
                    <td align="center"><%=ht.get("CAR_NO")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_START_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_END_DT")))%></td>
                    <td align="center"><%=ht.get("CON_MON")%></td>
                    <td align="center"><%=ht.get("GUBUN2_NM")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("F_REST_AMT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EXT_PAY_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MIN_EST_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("MAX_EST_DT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("RC_AMT")))%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("REST_AMT")))%></td>
                    <td align="center"><%=ht.get("CLS_ST")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CLS_DT")))%></td>
                </tr>
		            <%	}%>
                <tr>
                    <td colspan='9' align="center">합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td colspan='3'>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td colspan='2'>&nbsp;</td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="17" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr> 	  
  </table>
</form>
</body>
</html>