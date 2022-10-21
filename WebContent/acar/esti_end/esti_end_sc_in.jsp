<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.esti_mng.*" %>
<jsp:useBean id="EstiMngDb" scope="page" class="acar.esti_mng.EstiMngDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
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
	
	if(!s_mon.equals("")) s_mon = AddUtil.addZero(s_mon);
	if(!s_day.equals("")) s_day = AddUtil.addZero(s_day);
	
		
	
	Vector EstiEndList = EstiMngDb.getEstiList("N", br_id, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, s_dt, e_dt, "", s_kd, t_wd, "", "", s_year, s_mon, s_day);

%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
	//내용보기
	function EstiDisp(est_id){	
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.target = 'd_content';
		fm.submit();
	}
	
	function EstiMemo(est_id, user_id){
		var SUBWIN="./esti_memo_i.jsp?est_id="+est_id+"&user_id="+user_id;	
		window.open(SUBWIN, "EstiMemoDisp", "left=100, top=100, width=580, height=550, scrollbars=yes");
	}
//-->
</script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	
-->
</script>
</head>
<body>
<form action="../esti_ing/esti_ing_u.jsp" name="form1" method="POST">
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
  <input type="hidden" name="est_id" value="">          
  <input type="hidden" name="mode" value="end">            
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=5% class=title>연번</td>
                    <td width=10% class=title>영업사원</td>
                    <td width=18% class=title>거래처명</td>
                    <td width=25% class=title>차종</td>
                    <td width=10% class=title>마감일자</td>
                    <td width=8% class=title>담당자</td>
                    <td width=12% class=title>견적결과</td>
                    <td width=12% class=title>미체결내용</td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <% if(EstiEndList.size()>0){
    				for(int i=0; i<EstiEndList.size(); i++){ 
    //System.out.println(i);				
    					Hashtable ht = (Hashtable)EstiEndList.elementAt(i); %>
                <tr> 
                    <td width=5% align=center><%= i+1 %></td>
                    <td width=10% align=center>
        			  <span title='<%= ht.get("CAR_COMP_NM") %> <%= ht.get("CAR_OFF_NM") %>'><%=Util.subData(String.valueOf(ht.get("EMP_NM")), 5)%></span>
        			</td>
                    <td width=18% align=center>
        			  <span title='<%= ht.get("EST_NM") %> <%= ht.get("EST_MGR") %>'><%=Util.subData(String.valueOf(ht.get("EST_NM"))+" "+String.valueOf(ht.get("EST_MGR")), 10)%></span>			  
        			</td>
                    <td width=25% align=center>			  
                      <%if(String.valueOf(ht.get("CAR_TYPE")).equals("2")){%>
                      <font color="#990000">[<%= ht.get("CAR_NO") %>]</font> 
                      <span title='<%= ht.get("CAR_NAME") %>'><%=Util.subData(String.valueOf(ht.get("CAR_NAME")), 10)%></span> 
                      <%}else{%>
                      <span title='<%= ht.get("CAR_NAME") %>'><%=Util.subData(String.valueOf(ht.get("CAR_NAME")), 15)%></span> 			  
                      <%}%>			  
        			</td>
                    <td width=10% align=center><a href="javascript:EstiDisp('<%= ht.get("EST_ID") %>')"><%= AddUtil.ChangeDate2(String.valueOf(ht.get("END_DT"))) %></a></td>
                    <td width=8% align=center><%= ht.get("MNG_NM") %></td>
                    <td width=12% align=center><%= ht.get("END_TYPE_NM") %></td>
                    <td width=12% align=center><span title='<%= ht.get("CONT") %>'><%= ht.get("NEND_ST_NM") %></span></td>
                </tr>
              <% 		}
    			}else{ %>
                <tr> 
                    <td width=100% align='center'>해당 데이터가 없습니다.</td>
                </tr>
              <% } %>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>
