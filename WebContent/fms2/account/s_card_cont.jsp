<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.incom.* "%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String s_kd = request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");  //popup 요청한 페이지
	
	String s_cnt 		= request.getParameter("s_cnt")==null?"":request.getParameter("s_cnt");
	 			
	String t_wd_chk = request.getParameter("t_wd_chk")==null?"N":request.getParameter("t_wd_chk");
		
	String incom_dt 		= request.getParameter("incom_dt")==null?"":request.getParameter("incom_dt");
	int incom_seq			= request.getParameter("incom_seq")==null? 0:AddUtil.parseDigit(request.getParameter("incom_seq"));
	long incom_amt			= request.getParameter("incom_amt")==null? 0:AddUtil.parseDigit4(request.getParameter("incom_amt"));
	
	String dt = request.getParameter("dt")==null?"2":request.getParameter("dt");	
	String ref_dt1 = request.getParameter("ref_dt1")==null?"":request.getParameter("ref_dt1");
	String ref_dt2 = request.getParameter("ref_dt2")==null?"":request.getParameter("ref_dt2");
			
	Vector clients = new Vector();
	int client_size = 0;
		
	if ( !t_wd.equals("")) {
		clients = in_db.getIncomCardList(dt, ref_dt1, ref_dt2, s_kd, t_wd, asc, t_wd_chk);
		client_size = clients.size();

	}		

%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//검색하기
	function search(){
		var fm = document.form1;	
	
		if(fm.t_wd.value == ''){ alert('검색어를 입력하십시오.'); fm.t_wd.focus(); return; }	
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}
	
	
		//전체선택
	function AllSelect(){
		var fm = document.form1;
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "cid"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}	
	
	function ChangeDT(arg)
	{
		var theForm = document.form1;
		if(arg=="ref_dt1")
		{
		theForm.ref_dt1.value = ChangeDate(theForm.ref_dt1.value);
		}else if(arg=="ref_dt2"){
		theForm.ref_dt2.value = ChangeDate(theForm.ref_dt2.value);
		}	
	}	
	
		//등록하기
	function save(incom_dt, incom_seq, incom_amt, s_kd, t_wd, s_cnt){
		fm = document.form1;
				
		var len=fm.elements.length;
		var cnt=0;
		var clen=0;
		var idnum="";
		var id="";
		
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "cid"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}	
		
		if(cnt == 0){
		 	alert("카드를 선택하세요.");
			return;
		}	
				
		if(!confirm("선택하시겠습니까?"))	return;
		
	
		for(var j=0 ; j<len ; j++){
			var ck=fm.elements[j];		
			if(ck.name == "cid"){		
				if(ck.checked == true){
					id = id  + ck.value + ","
				   
				}
			}
			
		}			
		 
		opener.parent.c_foot.location.href 	= "/fms2/account/incom_reg_card_step2_sc.jsp?s_cnt="+s_cnt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&all_cid="+id+"&incom_dt="+incom_dt+"&incom_seq="+incom_seq+"&incom_amt="+incom_amt;		
		
		self.close();
	
	}	
		
//-->
</script>
</head>

<body>
<form name='form1' method='post' action='s_card_cont.jsp'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">     
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type='hidden' name='from_page' value='<%=from_page%>'> 
<input type="hidden" name="incom_dt" 			value="<%=incom_dt%>">
<input type="hidden" name="incom_seq" 		value="<%=incom_seq%>">
<input type="hidden" name="incom_amt" 		value="<%=incom_amt%>">
<input type="hidden" name="s_cnt"	value="<%=s_cnt%>">

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	 <tr> 
            <td>&nbsp;&nbsp;<img src="/acar/images/center/arrow_ggjh.gif" >&nbsp;
     			  <input type="radio" name="dt" value="2" <%if(dt.equals("2"))%>checked<%%>>
                당월 
               <input type="radio" name="dt" value="5" <%if(dt.equals("5"))%>checked<%%>>
                전월 
                <input type="radio" name="dt" value="3" <%if(dt.equals("3"))%>checked<%%>>
                조회기간                       
             <input type="text" name="ref_dt1" size="11" value="<%=ref_dt1%>" class="text" onBlur="javascript:ChangeDT('ref_dt1')">
              ~ 
              <input type="text" name="ref_dt2" size="11" value="<%=ref_dt2%>" class="text" onBlur="javascript:ChangeDT('ref_dt2')" > 
            
            &nbsp;</td>
   </tr>
    <tr> 
        <td>&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
            <select name='s_kd'>
              <option value='1' <%if(s_kd.equals("1"))%>selected<%%>>카드사</option>
              <option value='2' <%if(s_kd.equals("2"))%>selected<%%>>번호</option>
              <option value='3' <%if(s_kd.equals("3"))%>selected<%%>>적요</option>  
            </select>
            <input type="text" name="t_wd" value="<%=t_wd%>" size="15" class=text onKeyDown="javasript:enter()" style='IME-MODE: active'>   
            &nbsp;<a href="javascript:search()"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>     
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr></tr><tr></tr><tr></tr>
    	
    <tr> 
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=5%>연번</td>
                    <td class=title width=5%><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>                  
                    <td class=title width=14%>카드사</td>
                    <td class=title width=12%>카드번호</td>
                    <td class=title width=20%>적요</td>  
                    <td class=title width=15%>청구일</td>              
                    <td class=title width=15%>청구금액</td>              
                </tr>
          <%for (int i = 0 ; i < client_size ; i++){
				Hashtable ht = (Hashtable)clients.elementAt(i);%>
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><input type="checkbox" name="cid" value="<%=ht.get("INCOM_DT")%>^<%=ht.get("INCOM_SEQ")%>"></td>
                    <td><%=ht.get("CARD_NM")%></td>
                    <td><%=ht.get("CARD_NO")%></td>
                    <td><%=ht.get("REMARK")%></td>
                    <td><%=ht.get("INCOM_DT")%></td>
                    <td><%=Util.parseDecimal(String.valueOf(ht.get("INCOM_AMT")))%></td>
                        
                </tr>
          <%		}%>
            </table>
        </td>
    </tr>
    
    <tr> 
        <td align="center"><a href="javascript:save('<%=incom_dt%>', '<%=incom_seq%>', '<%=incom_amt%>', '<%=s_kd%>', '<%=t_wd%>', '<%=s_cnt%>');"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a> &nbsp;<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
</body>
</html>