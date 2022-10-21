<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*, acar.receive.*"%>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

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
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");	
	String gubun1 = request.getParameter("gubun1")==null?"6":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	String rent="";
	int total_su = 0;
	long total_amt = 0;	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	//해지정산 리스트
	Vector clss = re_db.getClsTransList(gubun2,  st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int cls_size = clss.size();
%>

<form name='form1' action='' method='post' target='d_content'>
<input type='hidden' name='fee_size' value='<%=cls_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width='1030'>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
	    <td class='line' width='400' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>					
                    <td width='40' class='title'>연번</td>	                  
        		   <td width='100' class='title'>계약번호</td>
        		   <td width='160' class='title'>상호</td>
        		   <td width='100' class=title>차량번호</td>
		    </tr>
	        </table>
	    </td>
	    <td class='line' width='630'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width='150' class='title'>차명</td>
                    <td width='80' class='title'>해지일자</td> 
                    <td width='60' class='title'>회차</td>
                    <td width='100' class='title'>금액</td>
                    <td width='80' class='title'>경과일수</td>
                    <td width='80' class='title'>보증보험</td>
                    <td width=80 class='title'>영업담당</td>
                </tr>
            </table>
	    </td>
    </tr>
<%	if(cls_size > 0){%>
    <tr>
	    <td class='line' width='400' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < cls_size ; i++){
			Hashtable cls = (Hashtable)clss.elementAt(i);
			//연체료 셋팅
			boolean flag = ae_db.calDelay((String)cls.get("RENT_MNG_ID"), (String)cls.get("RENT_L_CD"));%>
                <tr> 
                   <td width='40' align='center'><%=i+1%></td>               
                    <td width='100' align='center'><a href="javascript:parent.view_cls('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("CAR_MNG_ID")%>' )" onMouseOver="window.status=''; return true"><%=cls.get("RENT_L_CD")%></a></td>
                    <td width='160' align='center'><span title='<%=cls.get("FIRM_NM")%>'><a href="javascript:parent.view_client('<%=cls.get("RENT_MNG_ID")%>','<%=cls.get("RENT_L_CD")%>','<%=cls.get("RENT_ST")%>')" onMouseOver="window.status=''; return true"><%=Util.subData(String.valueOf(cls.get("FIRM_NM")), 9)%></a></span></td>
                    <td width=100 align='center'><span title='<%=cls.get("CAR_NO")%>'>
                      <%if(String.valueOf(cls.get("PREPARE")).equals("9") || String.valueOf(cls.get("PREPARE")).equals("4") ){%>
                  			  <font color="green"><%=Util.subData(String.valueOf(cls.get("CAR_NO")), 15)%></font>
                     <% }  else { %>
                    		<%=Util.subData(String.valueOf(cls.get("CAR_NO")), 15)%>
                     <%} %> 
                    </span></td>
                </tr>
          <%		}%>              
               <tr>                
        		  <td class="title" colspan=2 align='center'>합계</td>
                    <td class="title"  colspan=2 >&nbsp;</td>
                </tr>  
            </table>
	    </td>
	    <td class='line' width='630'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <%		for (int i = 0 ; i < cls_size ; i++){
			Hashtable cls = (Hashtable)clss.elementAt(i);

			%>
                <tr> 
                    <td width='150' align='center'><span title='<%=cls.get("CAR_NM")%> <%=cls.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(cls.get("CAR_NM"))+" "+String.valueOf(cls.get("CAR_NAME")), 9)%></span></td>
                    <td width='80' align='center'><%=AddUtil.ChangeDate2(String.valueOf(cls.get("CLS_DT")))%></td>                   
                    <td width='60' align='center'><%=cls.get("TM")%><%=cls.get("TM_ST")%></td>
                    <td width='100' align='right'><%=Util.parseDecimal(String.valueOf(cls.get("AMT")))%></td>                
                    <td width='80' align='right'><%=cls.get("DLY_DAYS")%>일</td>             
                      <td width='80' align='right'><%=Util.parseDecimal(String.valueOf(cls.get("GI_AMT")))%></td>             
                    <td width='80' align='center'><%=c_db.getNameById(String.valueOf(cls.get("BUS_ID2")), "USER")%></td>
                </tr>
          <%
				total_su = total_su + 1;
				total_amt = total_amt + AddUtil.parseLong(String.valueOf(cls.get("AMT")));
		  		}%>		  
                <tr> 
                    <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>                
                    <td class="title">&nbsp;</td>                
                    <td class="title" style='text-align:right'><%=Util.parseDecimal(total_amt)%></td>		
                    <td class="title">&nbsp;</td>
                      <td class="title">&nbsp;</td>
                    <td class="title">&nbsp;</td>		  			
                </tr>
            </table>
	    </td>
    </tr>
<%	}else{%>                     
    <tr>
	    <td class='line' width='400' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td align='center'>등록된 데이타가 없습니다</td>
		        </tr>
	        </table>
	    </td>
	    <td class='line' width='630'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
		            <td>&nbsp;</td>
		        </tr>
	        </table>
	    </td>
    </tr>
<% 	}%>
</table>
</form>
</body>
</html>
