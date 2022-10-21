<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.con_ins.*"%>
<jsp:useBean id="ai_db" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
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
	}	
	
	//등록하기
	function save(){
		fm = document.form1;
		
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
		 	alert("일괄 지출 처리할 건을 선택하세요.");
			return;
		}	
				
		if(!confirm("등록하시겠습니까?"))	return;
		fm.action = 'popup_auto_a.jsp';
		fm.submit();
	}

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "03", "02");	
	
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String f_list = request.getParameter("f_list")==null?"now":request.getParameter("f_list");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	int total_su = 0;
	long total_amt = 0;
	
	
	
	gubun3 = "3";//수금만 처리
	
	Vector inss = ai_db.getInsPayList(f_list, br_id, gubun1, gubun2, gubun3, gubun4, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc, gubun);
	int ins_size = inss.size();
%>
<form name='form1' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
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
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='go_url' value='/acar/con_ins/ins_frame_s.jsp'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='f_list' value='pay'>
<input type='hidden' name='size' value='<%=ins_size%>'>  
<table border="0" cellspacing="0" cellpadding="0" width=1000>
    <tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>일괄지출처리</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr>
        <td>
		    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=../images/center/arrow_crny.gif align=absmiddle>&nbsp; : 
			<input type="radio" name="work_st" value="1" checked>FMS지출
	    </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td class=line2></td>
    </tr>  
	<tr>
	    <td class=line>
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		        <tr valign="middle" align="center"> 
        		    <td class=title width=4%><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
        		    <td class=title width=4%>연번</td>
        		    <td class=title width=12%>계약번호</td>
        		    <td class=title width=20%>상호</td>
        		    <td class=title width=12%>차량번호</td>
        		    <td class=title width=17%>차명</td>
        		    <td class=title width=8%>보험사</td>
        		    <td class=title width=5%>회차</td>
        		    <td class=title width=10%>보험료</td>
        		    <td class=title width=8%>납부일</td>
		        </tr>
<%		for(int i = 0 ; i < ins_size ; i++){
				Hashtable ins = (Hashtable)inss.elementAt(i);%>
		        <tr> 
        		    <td align='center'>
        			  <input type="checkbox" name="ch_l_cd" value="<%=ins.get("CAR_MNG_ID")%>/<%=ins.get("INS_ST")%>/<%=ins.get("INS_TM")%>">
        			  <input type='hidden' name='pay_amt' value='<%=total_amt%>'>
        			</td>
        		    <td align='center'><%=i+1%></td>
        		    <td align='center'><%=ins.get("RENT_L_CD")%></td>
        		    <td align='center'><%=ins.get("FIRM_NM")%></td>
        		    <td align='center'><%=ins.get("CAR_NO")%></td>
        		    <td align='center'><%=ins.get("CAR_NM")%></td>			
        		    <td align='center'><%=ins.get("INS_COM_NM")%></td>
        		    <td align='center'><%=ins.get("INS_TM")%>회</td>
        		    <td align='right'><%=Util.parseDecimal(String.valueOf(ins.get("PAY_AMT")))%>원&nbsp;</td>			
        		    <td align='center'><%=ins.get("PAY_DT")%></td>
		        </tr>
  <%		total_amt = total_amt + Long.parseLong(String.valueOf(ins.get("PAY_AMT")));
		  }%>
				<tr>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title" align='center'><%=ins_size%>건</td>
					<td class="title">&nbsp;</td>	
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title">&nbsp;</td>
					<td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%>원&nbsp;</td>
					<td class="title">&nbsp;</td>					
				</tr>		  
	        </table>
	    </td>
	</tr>
	<tr>
		<td align='right'>
		  지출일자 : <input type='text' name='pay_dt' value='' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value);'>
		  <%if( auth_rw.equals("4") || auth_rw.equals("6")) {%>	
		  <a href="javascript:save()"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
		 <% } %> 
		  <a href='javascript:window.close();'><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a>
		</td>	
	</tr>	
	<tr>
		<td align='right'>
		  ( 지출일자가 없으면 지출예정일로 처리합니다. )
		</td>	
	</tr>		
</table>
<input type='hidden' name='total_amt' value=''>  
</form>  
</body>
</html>
