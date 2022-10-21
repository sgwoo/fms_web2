<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.asset.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동차관리 검색 페이지
	
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");

	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"5":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"desc":request.getParameter("asc");
	
	String chk1 = request.getParameter("chk1")==null?"2":request.getParameter("chk1");
	String chk = request.getParameter("chk1")==null?"0":request.getParameter("chk");
	
//	int alt_amt = 0;
			
	AssetDatabase as_db = AssetDatabase.getInstance();
	
	Vector vt = new Vector();
	
	if ( chk.equals("0") )  {		
		vt = as_db.getAssetGetListAll(chk1,st_dt,end_dt,s_kd);
	} else {
		vt = as_db.getAssetGetListAll1(chk1,st_dt,end_dt,s_kd);	
	}
	int cont_size = vt.size();
	
	long t_amt1[] = new long[1];  //기초가액
    long t_amt3[] = new long[1];  //충당금 증가
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	/* Title 고정 */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}
	
	//팝업윈도우 열기
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}		
	

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form  name="form1" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width="100%">
    <tr>
        <td>
            <table border=0 cellspacing=0 cellpadding=0 width="100%">    
                <tr>
                    <td class=line2></td>
                </tr>        	
            	<tr>
            		<td class=line>
            			<table border=0 cellspacing=1 width=100%>
                            <tr> 
                                <td width=30 class=title>연번</td>
                                <td width=100 class=title>차량번호</td>
                                <td width=80 class=title>자산코드</td>
                                <td class=title>자산명</td>
                              <!--  <td class=title>차종</td> -->
                                <td width=100 class=title>취득일</td>
                				<td width=200 class=title>내용</td>
                				<td width=120 class=title>취득액</td>
                			<!--	<td width=120 class=title>매각액</td> -->
            		        </tr>
              <%if(cont_size > 0){%>
                            <tr> 
                <%	for(int i = 0 ; i < cont_size ; i++){
            				Hashtable ht = (Hashtable)vt.elementAt(i); 
            				
            				long t1=0;
            				long t3=0;
            																		
            			    t1 = AddUtil.parseLong(String.valueOf(ht.get("CAP_AMT")));
            			    t3 = AddUtil.parseLong(String.valueOf(ht.get("SALE_AMT")));
            			    
            			    for(int j=0; j<1; j++){
            						t_amt1[j] += t1;
            						t_amt3[j] += t3;
            				}
            %>
            				              
                                <td width=30 align="center"><%=i+1%></td>
                                <td width=100 align="center"><%= ht.get("CAR_NO") %></td>
                                <td width=80 align="center"><%= ht.get("ASSET_CODE") %></td>
                                <td align="left"><%= ht.get("ASSET_NAME") %></td>
                         <!--       <td align="left"></td> -->
                			    <td width=100 align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("ASSCH_DATE")))%></td>
                                <td width=200 align="center"><%=ht.get("ASSCH_RMK")%></td>	
                                <td width=120 align="right"><%=Util.parseDecimal(t1)%></td>	
                          <!--      <td width=120 align="right"><%=Util.parseDecimal(t3)%></td>	-->
                            </tr>
                 <%	}%>
            	  		    <tr> 
            	                <td colspan="6"  class=title align="center">합계</td>
            	                <td width='120'  class=title style='text-align:right'><%=Util.parseDecimal(t_amt1[0])%></td>				
            	     <!--       <td width='120'  class=star align='right'><%=Util.parseDecimal(t_amt3[0])%></td>		-->	
            	            </tr>
            <%	}else{	%>    		  
                            <tr> 
                                <td colspan="8" align="center">&nbsp;등록된 데이타가 없습니다.</td>
                            </tr>
        <%}%>			  
			            </table>
		            </td>
	            </tr>	 	 
            </table>
        </td>
    </tr>
</table>

<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="br_id" value="<%=br_id%>">
<input type="hidden" name="st_dt" value="<%=st_dt%>">
<input type="hidden" name="end_dt" value="<%=end_dt%>">
<input type="hidden" name="gubun1" value="<%=gubun1%>">
<input type="hidden" name="s_kd" value="<%=s_kd%>">
<input type="hidden" name="t_wd" value="<%=t_wd%>">
<input type="hidden" name="sort" value="<%=sort%>">
<input type="hidden" name="asc" value="<%=asc%>">
<input type="hidden" name="car_mng_id" value="">
<input type="hidden" name="asset_code" value="">
<input type="hidden" name="assch_seri" value="">
<input type="hidden" name="chk" value="">
<input type="hidden" name="cmd" value="">

</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</body>
</html>


