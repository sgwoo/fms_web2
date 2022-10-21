<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.car_mst.*, acar.doc_settle.*, acar.client.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();

	String doc_no 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String doc_st 	= request.getParameter("doc_st")==null?"":request.getParameter("doc_st");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");

	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
		
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	DocSettleBean doc17 = d_db.getDocSettle(doc_no);
	
	//문서품의
	DocSettleBean doc_var = d_db.getDocSettleVar(doc_no, 1);
		
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
<%if(doc17.getDoc_no().equals("") || mode.equals("upd")){%>
function save(){
	var fm = document.form1;
	
	if(fm.var01[0].checked == false && fm.var01[1].checked == false && fm.var01[2].checked == false && fm.var01[3].checked == false){ alert('질문1의 답변을 선택하십시오.'); return; }
	if(fm.var02[0].checked == false && fm.var02[1].checked == false && fm.var02[2].checked == false && fm.var02[3].checked == false && fm.var02[4].checked == false && fm.var02[5].checked == false){ alert('질문2의 답변을 선택하십시오.'); return; }
	if(fm.var03.value == '' && fm.var04[0].checked == false && fm.var04[1].checked == false){ alert('질문3의 답변을 선택하십시오.'); return; }
	if(fm.var05[0].checked == false && fm.var05[1].checked == false && fm.var05[2].checked == false){ alert('질문4의 답변을 선택하십시오.'); return; }
	if(fm.var05[1].checked == true && fm.var06.value == '' && fm.var07.value == '' && fm.var08.value == ''){ alert('질문4의 부서/성명/직위를 입력하십시오.'); return; }
	
	if(!confirm('등록하시겠습니까?'))		return;
	fm.action='doc_com_dir_pur_a.jsp';			
	fm.target = "i_no";
	fm.submit();
}
<%}%>
//-->
</script>
</head>
<body leftmargin="15" topmargin="1">
<form action="" name="form1" method="POST" >
<input type="hidden" name="doc_no" value="<%= doc_no %>">
<input type="hidden" name="doc_st" value="<%= doc_st %>">
<input type="hidden" name="rent_mng_id" value="<%= rent_mng_id %>">
<input type="hidden" name="rent_l_cd" value="<%= rent_l_cd %>">
<input type="hidden" name="mode" value="<%= mode %>">

  <table width='600' height="230" border="0" cellpadding="0" cellspacing="0">
    <tr> 
      <td height="30" align="center"></td>
    </tr>
    <tr> 
      <td height="50" align="center" style="font-size : 16pt;"><b>법인고객 자동차 영업직원 활동 보고서</b></td>
    </tr>
    <tr> 
      <td height="30" align='center'></td>
    </tr>
    <tr> 
      <td style="font-size : 11pt;">※ &nbsp;계약 및 출고/인도 진행과정에서 자연스럽게 파악된 정보를 기재하고, 고객에게
          <br>번거롭게 캐물어서 정보를 파악해서는 안됩니다. 아래 문항에 아는 대로 기재하되,
          <br>가급적 '모름'의 체크는 줄여 주세요.
      </td>
    </tr>
    <tr>
        <td height="10"></td>
    </tr>      
    <tr> 
      <td style="font-size : 9pt;">(FMS에 입력하기 전에 메모를 위한 양식이니, 고객 앞에서 이런 내용을 기재해서는 안됩니다.)</td>
    </tr>
    <tr> 
      <td height="20" align='center'></td>
    </tr>
    <tr bgcolor="#000000"> 
      <td align='center'> 
	    <table width="100%" height="100%" border="0" cellspacing="1" cellpadding="0">
          <tr align="center"> 
            <td bgcolor="#A6FFFF" style="font-size : 10pt;" width="15%" height="40">상&nbsp;&nbsp;호</td>
            <td bgcolor="#FFFFFF" style="font-size : 10pt;" width="35%"><%=client.getFirm_nm()%></td>
            <td bgcolor="#A6FFFF" style="font-size : 10pt;" width="15%">차&nbsp;&nbsp;종</td>
            <td bgcolor="#FFFFFF" style="font-size : 10pt;" width="35%"><%=cm_bean.getCar_nm()%></td>		
          </tr>
          <tr align="center"> 
            <td bgcolor="#A6FFFF" style="font-size : 10pt;" height="40">계약일</td>
            <td bgcolor="#FFFFFF" style="font-size : 10pt;"><%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
            <td bgcolor="#A6FFFF" style="font-size : 10pt;">비&nbsp;&nbsp;고</td>
            <td bgcolor="#FFFFFF" style="font-size : 10pt;"><%=doc17.getEtc()%><%if(doc17.getDoc_no().equals("")){%><input type='text' size='22' name='etc' class='whitetext' value='<%=doc17.getEtc()%>'><%}%></td>		
          </tr>
        </table>
	  </td>
    </tr>
    <tr> 
      <td height="30"></td>
    </tr>
    <tr> 
      <td style="font-size : 11pt;">1. 이번 차량 장기대여 진행과정을 잘 알고 있는 자동차 영업직원이 있나요?</td>
    </tr>    	
    <tr> 
      <td height="10"></td>
    </tr>
    <tr>
      <td width="100%" align='center'>
	    <table width="80%" border="0" cellspacing="1" cellpadding="0">
          <tr height="20">
            <td style="font-size : 11pt;" width="33%" >(1) 있다 <input type='radio' name="var01" value='1' <%if(doc_var.getVar01().equals("1")){%>checked<%}%>></td>            
            <td style="font-size : 11pt;" width="33%" >(2) 없다 <input type='radio' name="var01" value='2' <%if(doc_var.getVar01().equals("2")){%>checked<%}%>></td>
            <td style="font-size : 11pt;" width="33%" >(3) 모름 <input type='radio' name="var01" value='3' <%if(doc_var.getVar01().equals("3")){%>checked<%}%>></td>
          </tr>
          <tr height="20">
            <td style="font-size : 11pt;" colspan='3'>(4) 자체영업 신규계약이라 파악할 필요성이 낮음 <input type='radio' name="var01" value='4' <%if(doc_var.getVar01().equals("4")){%>checked<%}%>></td>            
          </tr>
        </table>
      </td>
    </tr>  
    <tr> 
      <td height="15"></td>
    </tr>
    <tr> 
      <td style="font-size : 11pt;">2. 그 자동차 영업직원은 어느 자동차 회사 소속인가요?</td>
    </tr>    	
    <tr> 
      <td height="10"></td>
    </tr>
    <tr>
      <td width="100%" align='center'>
	    <table width="80%" border="0" cellspacing="1" cellpadding="0">
          <tr height="20">
            <td style="font-size : 11pt;" width="50%" >(1) 현대자동차 <input type='radio' name="var02" value='1' <%if(doc_var.getVar02().equals("1")){%>checked<%}%>></td>            
            <td style="font-size : 11pt;" width="50%" >(2) 기타 국내 자동차회사 <input type='radio' name="var02" value='2' <%if(doc_var.getVar02().equals("2")){%>checked<%}%>></td>
          </tr>
          <tr height="20">
            <td style="font-size : 11pt;" colspan='3'>(3) 수입자동차회사 <input type='radio' name="var02" value='3' <%if(doc_var.getVar02().equals("3")){%>checked<%}%>></td>            
          </tr>
          <tr height="20">
            <td style="font-size : 11pt;" colspan='3'>(4) 에이젼트 소개 영업건이라 파악하기 곤란함 <input type='radio' name="var02" value='4' <%if(doc_var.getVar02().equals("4")){%>checked<%}%>></td>            
          </tr>
          <tr height="20">
            <td style="font-size : 11pt;">(5) 모름 <input type='radio' name="var02" value='5' <%if(doc_var.getVar02().equals("5")){%>checked<%}%>></td>            
            <td style="font-size : 11pt;">(6) 해당 사항 없음 <input type='radio' name="var02" value='6' <%if(doc_var.getVar02().equals("6")){%>checked<%}%>></td>
          </tr>
        </table>
      </td>
    </tr>  
    <tr> 
      <td height="15"></td>
    </tr>
    <tr> 
      <td style="font-size : 11pt;">3. 그 자동차 영업직원은 해당 업체 담당자 (또는 대표이사 및 주요 직원)와 <br>&nbsp;&nbsp;&nbsp;얼마동안 알고 지냈나요?</td>
    </tr>    	
    <tr> 
      <td height="10"></td>
    </tr>
    <tr>
      <td width="100%" align='center'>
	    <table width="80%" border="0" cellspacing="1" cellpadding="0">
          <tr height="20">
            <td style="font-size : 11pt;" colspan='3'>(1) 알고 지낸 기간 (몇 개월 또는 몇 년으로 기재해 주세요) 
            <br><%if(doc17.getDoc_no().equals("") || mode.equals("upd")){%><input type='text' size='35' name='var03' class='text' value='<%=doc_var.getVar03()%>'><%}else{%><%=doc_var.getVar03()%><%}%>
            </td>            
          </tr>
          <tr height="20">
            <td style="font-size : 11pt;" width="50%" >(2) 모름 <input type='radio' name="var04" value='2' <%if(doc_var.getVar04().equals("2")){%>checked<%}%>></td>            
            <td style="font-size : 11pt;" width="50%" >(3) 해당 사항 없음 <input type='radio' name="var04" value='3' <%if(doc_var.getVar04().equals("3")){%>checked<%}%>></td>
          </tr>
        </table>
      </td>
    </tr>  
    <tr> 
      <td height="10"></td>
    </tr>
    <tr> 
      <td style="font-size : 11pt;">4. 위의 정보는 누구에게 들었나요?</td>
    </tr>    	
    <tr> 
      <td height="10"></td>
    </tr>
    <tr>
      <td width="100%" align='center'>
	    <table width="80%" border="0" cellspacing="1" cellpadding="0">
          <tr height="20">
            <td style="font-size : 11pt;">(1) 간접영업 건이라 소개 영업직원 또는 에이전트에게 들음 <input type='radio' name="var05" value='1' <%if(doc_var.getVar05().equals("1")){%>checked<%}%>></td>            
          </tr>
          <tr height="20">
            <td style="font-size : 11pt;">(2) 고객 업체 분에게 들음 (부서,성명,직위 기재) <input type='radio' name="var05" value='2' <%if(doc_var.getVar05().equals("2")){%>checked<%}%>></td>            
          </tr>
          <tr height="20">
            <td bgcolor="#000000">
	          <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr bgcolor="#FFFFFF" align="center">
                  <td style="font-size : 10pt;" width="10%" >부서</td>            
                  <td style="font-size : 10pt;" width="23%" ><%if(doc17.getDoc_no().equals("") || mode.equals("upd")){%><input type='text' size='13' name='var06' class='text' value='<%=doc_var.getVar06()%>'><%}else{%><%=doc_var.getVar06()%><%}%></td>
                  <td style="font-size : 10pt;" width="10%" >성명</td>
                  <td style="font-size : 10pt;" width="23%" ><%if(doc17.getDoc_no().equals("") || mode.equals("upd")){%><input type='text' size='13' name='var07' class='text' value='<%=doc_var.getVar07()%>'><%}else{%><%=doc_var.getVar07()%><%}%></td>
                  <td style="font-size : 10pt;" width="10%" >직위</td>
                  <td style="font-size : 10pt;" width="23%" ><%if(doc17.getDoc_no().equals("") || mode.equals("upd")){%><input type='text' size='13' name='var08' class='text' value='<%=doc_var.getVar08()%>'><%}else{%><%=doc_var.getVar08()%><%}%></td>
                </tr>
              </table>            
            </td>            
          </tr>
          <td style="font-size : 11pt;">(3) 해당 사항 없음 <input type='radio' name="var05" value='3' <%if(doc_var.getVar05().equals("3")){%>checked<%}%>></td>
        </table>
      </td>
    </tr>                   	
    <tr> 
      <td height="10"></td>
    </tr>    <tr> 
      <td>5. 기타 메모</td>
    </tr>	  
    <tr bgcolor="#000000">
      <td width="100%" align='center'>
	    <table width="100%" border="0" cellspacing="1" cellpadding="0">
          <tr bgcolor="#FFFFFF" align="center"  height="50">
            <td style="font-size : 10pt;">
              <%if(!doc17.getDoc_no().equals("") && !mode.equals("upd")){%>
              <%=doc_var.getVar09()%>
              <%}else{%>
              <textarea rows='2' cols='50' name='var09'><%=doc_var.getVar09()%></textarea>
              <%}%>                          
            </td>            
          </tr>
        </table>
      </td>
    </tr>
    <%if(doc17.getDoc_no().equals("")){%>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td align="right">
	      <a href="javascript:save()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;	
		  <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>	  
		</td>
    </tr>	    
    <%}%>
    <%if(mode.equals("upd")){%>
    <tr> 
        <td>&nbsp;</td>
    </tr>
    <tr> 
        <td align="right">
	      <a href="javascript:save()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a>&nbsp;	
		  <a href="javascript:window.close()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>	  
		</td>
    </tr>	    
    <%}%>    
  </table>
</form>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
