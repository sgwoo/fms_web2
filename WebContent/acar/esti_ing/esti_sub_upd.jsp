<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.esti_mng.*" %>
<jsp:useBean id="EstiMngDb" class="acar.esti_mng.EstiMngDatabase" scope="page" />
<jsp:useBean id="EstiRegBn" class="acar.esti_mng.EstiRegBean" scope="page"/>
<jsp:useBean id="EstiListBn" class="acar.esti_mng.EstiListBean" scope="page"/>
<jsp:useBean id="EstiContBn" class="acar.esti_mng.EstiContBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String est_st = request.getParameter("est_st")==null?"":request.getParameter("est_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트
	int user_size = users.size();
	
	EstiContBn = EstiMngDb.getEstiCont(est_id, seq);
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="../../include/table.css">
<script language="JavaScript">
<!--
	function EstiContUpd(){
		var fm = document.form1;		
		if(fm.reg_dt.value == '')				{ alert('등록(마감)일자를 입력하십시오'); 	return; }
		if(fm.reg_id.value == '')				{ alert('등록자를 선택하십시오'); 			return; }

	  	<%if(EstiContBn.getEnd_type().equals("")){%>
			if(fm.cont.value == '')				{ alert('내용을 입력하십시오'); 			return; }		
		<%}else{%>			
			if(fm.end_type.value == 'N'){
				if(fm.nend_st.value == '')		{ alert('미체결구분을 선택하십시오.'); 		return; }
				if(fm.nend_cau.value == '')		{ alert('미체결사유를 선택하십시오.'); 		return; }
			}
		<%}%>			

		if(!confirm('수정하시겠습니까?')){	return; }
		fm.action = 'esti_sub_u_a.jsp';
		fm.target = "i_no";
		fm.submit();
	}	
	
	//미체결내용
	function nend_display(st){
		var fm = document.form1;	
		if(st == 'N'){
			tr_nend1.style.display	= '';
			tr_nend2.style.display	= '';			
		}else{
			tr_nend1.style.display	= 'none';	
			tr_nend2.style.display	= 'none';		
		}		
	}
	
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=800>
  <form action="./esti_sub_u_a.jsp" name="form1" method="POST" >
    <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
    <input type="hidden" name="br_id" value="<%=br_id%>">
    <input type="hidden" name="user_id" value="<%=user_id%>">
    <input type="hidden" name="gubun1" value="<%=gubun1%>">
    <input type="hidden" name="gubun2" value="<%=gubun2%>">
    <input type="hidden" name="gubun3" value="<%=gubun3%>">
    <input type="hidden" name="gubun4" value="<%=gubun4%>">
    <input type="hidden" name="gubun5" value="<%=gubun5%>">    
    <input type="hidden" name="gubun6" value="<%=gubun6%>">    	
    <input type="hidden" name="s_dt" value="<%=s_dt%>">
    <input type="hidden" name="e_dt" value="<%=e_dt%>">
    <input type="hidden" name="s_kd" value="<%=s_kd%>">
    <input type="hidden" name="t_wd" value="<%=t_wd%>">
    <input type="hidden" name="s_year" value="<%=s_year%>">
    <input type="hidden" name="s_mon" value="<%=s_mon%>">
    <input type="hidden" name="s_day" value="<%=s_day%>">	
    <input type="hidden" name="est_id" value="<%=est_id%>">
    <input type="hidden" name="seq" value="<%=seq%>">	
	<input type="hidden" name="est_st" value="<%=est_st%>">		
<!--    <input type="hidden" name="end_type" value="<%= EstiContBn.getEnd_type()%>">-->
    <input type="hidden" name="cmd" value="">
    <tr> 
      <td colspan="2"><font color="navy">영업지원-> </font><font color="red">견적진행내용 수정</font> 
      </td>
    </tr>
    <tr> 
      <td class=line> 
        <table border="0" cellspacing="1" width=800>
          <tr> 
            <td class=title width="80">등록일자</td>
            <td width="320">
              <input type='text' name='reg_dt' value='<%= AddUtil.ChangeDate2(EstiContBn.getReg_dt())%>' size='11' class='text' onBlur='javascript:this.value = ChangeDate(this.value);'>
			  </td>
            <td class=title width="80">등록자</td>
            <td width="320">
              <select name="reg_id">
                <option value="">전체</option>
                <%	if(user_size > 0){
							for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
                <option value='<%=user.get("USER_ID")%>' <%if(EstiContBn.getReg_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                <%		}
					}		%>
              </select>
            </td>
          </tr>
		  <%if(EstiContBn.getEnd_type().equals("")){%>
          <tr> 
            <td class=title>제목</td>
            <td colspan="3"> 
              <input type="text" name="title" value="<%= EstiContBn.getTitle()%>" size="100" class=text>
            </td>
          </tr>
		  <%}else{%>
          <tr> 
            <td class=title>마감결과</td>
            <td colspan="3"> 
              <input type="radio" name="end_type" value="Y" <%if(EstiContBn.getEnd_type().equals("Y"))%>checked<%%>>
              계약체결 
              <input type="radio" name="end_type" value="N" <%if(EstiContBn.getEnd_type().equals("N"))%>checked<%%>>
              계약미체결</td>
          </tr>
		  <%if(EstiContBn.getEnd_type().equals("N")){%>
          <tr> 
            <td class=title>미체결구분</td>
            <td> 
              <select name="nend_st">
                <option value="" >= 선 택 =</option>
                <option value="1" <%if(EstiContBn.getNend_st().equals("1"))%>selected<%%>>타사계약</option>
                <option value="2" <%if(EstiContBn.getNend_st().equals("2"))%>selected<%%>>자가용구입</option>
                <option value="3" <%if(EstiContBn.getNend_st().equals("3"))%>selected<%%>>장기보류</option>
                <option value="4" <%if(EstiContBn.getNend_st().equals("4"))%>selected<%%>>기타</option>
              </select>
            </td>
            <td class=title>미체결사유</td>
            <td> 
              <select name="nend_cau">
                <option value="" >= 선 택 =</option>			  
                <option value="1" <%if(EstiContBn.getNend_cau().equals("1"))%>selected<%%>>대여료</option>
                <option value="2" <%if(EstiContBn.getNend_cau().equals("2"))%>selected<%%>>선수금</option>
                <option value="3" <%if(EstiContBn.getNend_cau().equals("3"))%>selected<%%>>보증보험</option>
                <option value="4" <%if(EstiContBn.getNend_cau().equals("4"))%>selected<%%>>신용</option>
                <option value="5" <%if(EstiContBn.getNend_cau().equals("5"))%>selected<%%>>부가세</option>				
                <option value="6" <%if(EstiContBn.getNend_cau().equals("6"))%>selected<%%>>인지도</option>
                <option value="7" <%if(EstiContBn.getNend_cau().equals("7"))%>selected<%%>>기타</option>
              </select>
            </td>
          </tr>		
		  <%}%>	  
		  <%}%>		  
          <tr> 
            <td class=title>내용</td>
            <td colspan="3"> 
              <textarea name="cont" cols=100 rows=5><%= EstiContBn.getCont()%></textarea>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td align="right">
	  <a href="javascript:EstiContUpd();"><img src="/images/update.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
	  &nbsp;<a href="javascript:window.close();"> <img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
	</td>
    </tr>	
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize> 
</iframe> 
</body>
</html>