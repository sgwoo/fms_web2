<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.common.*, acar.util.*, acar.watch.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	WatchDatabase wc_db = WatchDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(gubun1.equals("")){
		gubun1 = "1";
	}

	//ARS 프로시저 - 선처리
	String  d_flag1 =  wc_db.call_sp_ars_call_stat();
	
	//ARS call 현황
	Vector vt = wc_db.ArsCallStatSDay(gubun1, gubun2, gubun3, st_dt, end_dt);
	int vt_size = vt.size();
	
	//영업소리스트
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function Search(){
	var fm = document.form1;
	fm.action="ars_call_stat_sday_sc.jsp";
	fm.target="_self";
	fm.submit();
}
function display_pop(id){
	var taxInvoice = window.open("about:blank", "Stat", "resizable=no,  scrollbars=yes, status=yes, left=50,top=20, width=850px, height=250px");
	document.form1.id.value = id;
	document.form1.action="ars_call_stat_sday_list.jsp";
	document.form1.target="Stat";		
	document.form1.submit();
}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='ars_call_stat_sday_sc.jsp' method='post' target='t_content'>
<input type='hidden' name='call_user_id' value=''>
<input type='hidden' name='id' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1730>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ARS수신현황 </span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td>
            <table border=0 cellspacing=1>
                <tr> 
                    <td>&nbsp;
                        <select name='gubun1'>
              <option value="1" <%if(gubun1.equals("1"))%>selected<%%>>당일</option>
              <option value="2" <%if(gubun1.equals("2"))%>selected<%%>>어제</option>
              <option value="3" <%if(gubun1.equals("3"))%>selected<%%>>그저께</option>
              <option value="7" <%if(gubun1.equals("7"))%>selected<%%>>그끄저께</option>
              <option value="4" <%if(gubun1.equals("4"))%>selected<%%>>당월</option>
              <option value="5" <%if(gubun1.equals("5"))%>selected<%%>>전월</option>
              <option value="6" <%if(gubun1.equals("6"))%>selected<%%>>기간</option>
            </select>
			      &nbsp;
            <input type="text" name="st_dt" size="10" value="<%=st_dt%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value);'>
			      ~
			      <input type="text" name="end_dt" size="10" value="<%=end_dt%>" class="text" onBlur='javascript:this.value=ChangeDate(this.value);'>
			      	&nbsp;&nbsp;&nbsp;
			      	구분 : 
			      	<select name='gubun2'>
              <option value=""  <%if(gubun2.equals(""))%>selected<%%>>전체</option>
              <option value="6" <%if(gubun2.equals("6"))%>selected<%%>>사고</option>
              <option value="7" <%if(gubun2.equals("7"))%>selected<%%>>긴급출동</option>
              <option value="8" <%if(gubun2.equals("8"))%>selected<%%>>정비</option>
              <option value="9" <%if(gubun2.equals("9"))%>selected<%%>>기타</option>              
              <option value="10" <%if(gubun2.equals("10"))%>selected<%%>>알수없음</option>              
              <option value="1" <%if(gubun2.equals("1"))%>selected<%%>>통화</option>
              <option value="2" <%if(gubun2.equals("2"))%>selected<%%>>안내문</option>
              <option value="3" <%if(gubun2.equals("3"))%>selected<%%>>상담요청</option>
              <option value="4" <%if(gubun2.equals("4"))%>selected<%%>>연결실패</option>              
              <option value="11" <%if(gubun2.equals("11"))%>selected<%%>>당직대상</option>
              <option value="12" <%if(gubun2.equals("12"))%>selected<%%>>당직비대상</option>
            </select>					
            &nbsp;&nbsp;&nbsp;
            지점 :
            <select name='gubun3'>
              <option value=''>전체</option>
              <%if(brch_size > 0)	{
        					for (int i = 0 ; i < brch_size ; i++){
        						Hashtable branch = (Hashtable)branches.elementAt(i);
        						if(String.valueOf(branch.get("BR_NM")).equals("포천영업소")||String.valueOf(branch.get("BR_NM")).equals("파주영업소")||String.valueOf(branch.get("BR_NM")).equals("김해영업소")||String.valueOf(branch.get("BR_NM")).equals("울산지점")){
        							continue;
        						}
        						%>
              <option value='<%=branch.get("BR_ID")%>' <%if(gubun3.equals(String.valueOf(branch.get("BR_ID")))){%> selected <%}%>><%= branch.get("BR_NM")%></option>
              <%		}
        				}
        			%>
            </select>
            			  &nbsp;<a href="javascript:Search();"><img src=/acar/images/center/button_search.gif align=absmiddle border=0></a>
					</td>
                </tr>
            </table>
        </td>
    </tr>	 	     
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td rowspan='2' width='50' class='title'>연번</td>
                    <td colspan='4' class='title'>발신자</td>
                    <td rowspan='2' width='100' class='title'>수신지점</td>
                    <td colspan='4' class='title'>연결번호</td>
                    <td colspan='4' class='title'>연결현황</td>
                    <td colspan='5' class='title'>업무구분</td>
                    <td colspan='2' class='title'>당직수당</td>                    
                </tr>
                <tr>
                    <td width='100' class='title'>전화번호</td>
                    <td width='200' class='title'>거래처명</td>
                    <td width='100' class='title'>차량번호</td>
                    <td width='150' class='title'>종료일시</td>
                    <td width='50' class='title'>구분</td>
                    <td width='100' class='title'>지점</td>
                    <td width='50' class='title'>담당자</td>
                    <td width='100' class='title'>전화번호</td>
                    <td width='70' class='title'>통화</td>
                    <td width='70' class='title'>안내문</td>
                    <td width='70' class='title'>상담요청</td>
                    <td width='70' class='title'>연결실패</td>
                    <td width='70' class='title'>사고</td>
                    <td width='70' class='title'>긴급출동</td>
                    <td width='70' class='title'>정비</td>
                    <td width='70' class='title'>기타</td>
                    <td width='70' class='title'>알수없음</td>
                    <td width='50' class='title'>대상</td>
                    <td width='50' class='title'>비대상</td>
                </tr>                
                <%	if(vt_size > 0){
		            	for (int i = 0 ; i < vt_size ; i++){
				            Hashtable ht = (Hashtable)vt.elementAt(i);				            
				%>
                <tr>
                    <td align=center><%=i+1%></td>
                    <td align=center><%=ht.get("CID")%></td>
                    <td align=center><%=ht.get("FIRM_NM")%></td>
                    <td align=center><%=ht.get("CAR_NO")%></td>
                    <td align=center><%=ht.get("HANGUP_TIME")%></td>
                    <td align=center><%=ht.get("ACCESS_NM")%><%if(String.valueOf(ht.get("ACCESS_NM")).equals("")){%><%=ht.get("ACCESS_NUMBER")%><%}%></td>
                    <td align=center>
                      <%if(String.valueOf(ht.get("USER_TYPE")).equals("2")||String.valueOf(ht.get("USER_TYPE")).equals("3")){%>
                    	  <a href="javascript:display_pop('<%=ht.get("ID")%>')"><%if(String.valueOf(ht.get("USER_TYPE")).equals("2")){%>부1<%}else if(String.valueOf(ht.get("USER_TYPE")).equals("3")){%>부2<%}%></a>
                      <%} %>                      
                      <%if(String.valueOf(ht.get("USER_TYPE")).equals("1")){%>정<%}%>                      
                    </td>
                    <td align=center><%=ht.get("BR_NM")%></td>
                    <td align=center><%=ht.get("USER_NM")%></td>
                    <td align=center><%=ht.get("REDIRECT_NUMBER")%></td>
                    <td align=center><%=ht.get("STAT1")%></td>
                    <td align=center><%=ht.get("STAT2")%>
                      <%if(!String.valueOf(ht.get("STAT1")).equals("")&&String.valueOf(ht.get("STAT2")).equals("")&&(String.valueOf(ht.get("STAT6")).equals("O")||String.valueOf(ht.get("STAT7")).equals("O")||String.valueOf(ht.get("STAT8")).equals("O"))){%><%=ht.get("TIME")%><%}%>     
                    </td>
                    <td align=center><%=ht.get("STAT3")%></td>
                    <td align=center><%=ht.get("STAT4")%></td>
                    <td align=center><%=ht.get("STAT6")%></td>
                    <td align=center><%=ht.get("STAT7")%></td>
                    <td align=center><%=ht.get("STAT8")%></td>
                    <td align=center><%=ht.get("STAT9")%></td>
                    <td align=center><%=ht.get("STAT10")%></td>                    
                    <td align=center><%=ht.get("STAT11")%></td>
                    <td align=center><%if(!String.valueOf(ht.get("STAT11")).equals("O")){%>O<%}%></td>
                </tr>                   
		            <%	}%>                		            
		            <%}else{%>
                <tr>
                    <td colspan="21" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>    
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
