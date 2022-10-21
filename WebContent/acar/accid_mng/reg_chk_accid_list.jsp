<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.accid.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	//사고중복등록리스트
	Vector vt = as_db.getRegChkAccidList();
	int vt_size = vt.size();

%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post'>

<table border="0" cellspacing="0" cellpadding="0" width=1090>
    <tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1><span class=style5>사고중복등록리스트</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>

    <tr><td class=h></td></tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class="line"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td width=30 class='title'>연번</td>
                    <td width=100 class='title'>상호</td>
                    <td width=70 class='title'>영업담당</td>
                    <td width=100 class='title'>계약번호</td>
                    <td width=70 class='title'>차량<br>관리번호</td>
                    <td width=70 class='title'>사고<br>관리번호</td>
                    <td width=70 class='title'>차량번호</td>
                    <td width=70 class='title'>사고구분</td>
                    <td width=100 class='title'>사고일시</td>
                    <td width=70 class='title'>등록일</td>
                    <td width=70 class='title'>등록자</td>
                    <td width=70 class='title'>정비비</td>
                    <td width=50 class='title'>정비<br>유무</td>                    
                    <td width=50 class='title'>대차<br>유무</td>
                    <td width=50 class='title'>사진<br>갯수</td>
                    <td width=50 class='title'>대차료<br>유무</td>                    
                </tr>
                <%	for(int i = 0 ; i < vt_size ; i++){
    				Hashtable ht = (Hashtable)vt.elementAt(i);
    				
    				String not_list_chk = String.valueOf(ht.get("CAR_MNG_ID"))+""+String.valueOf(ht.get("ACCID_ID"));
    					
    				if(not_list_chk.equals("008928012599")) continue;
    				if(not_list_chk.equals("008928012639")) continue;
    				if(not_list_chk.equals("004783008988")) continue;
    				if(not_list_chk.equals("004783008994")) continue;
    				if(not_list_chk.equals("007791010399")) continue;
    				if(not_list_chk.equals("007791010400")) continue;
    				if(not_list_chk.equals("003000005520")) continue;
    				if(not_list_chk.equals("003000005521")) continue;
    				if(not_list_chk.equals("004044005262")) continue;
    				if(not_list_chk.equals("004044005263")) continue;
    				if(not_list_chk.equals("008359012129")) continue;
    				if(not_list_chk.equals("008359012128")) continue;
    				if(not_list_chk.equals("005360011122")) continue;
    				if(not_list_chk.equals("005360011121")) continue;
    				if(not_list_chk.equals("006296008812")) continue;
    				if(not_list_chk.equals("006296008813")) continue;
    				if(not_list_chk.equals("005448013126")) continue;
    				if(not_list_chk.equals("005448013346")) continue;
    				if(not_list_chk.equals("008052014822")) continue;
    				if(not_list_chk.equals("008052015008")) continue;
    				if(not_list_chk.equals("008844012272")) continue;
    				if(not_list_chk.equals("008844013919")) continue;
    				if(not_list_chk.equals("009515013713")) continue;
    				if(not_list_chk.equals("009515013711")) continue;
    				if(not_list_chk.equals("007922015793")) continue;
    				if(not_list_chk.equals("007922015792")) continue;    				
    				if(not_list_chk.equals("019384025801")) continue;
    				if(not_list_chk.equals("019384025901")) continue;
    				if(not_list_chk.equals("013869024253")) continue;
    				if(not_list_chk.equals("013869024251")) continue;
    				if(not_list_chk.equals("016139023126")) continue;
    				if(not_list_chk.equals("016139023127")) continue;
    				if(not_list_chk.equals("014296019097")) continue;
    				if(not_list_chk.equals("014296019251")) continue;
    				if(not_list_chk.equals("016738025725")) continue;
    				if(not_list_chk.equals("012369022413")) continue;    				
    				if(not_list_chk.equals("021930027535")) continue;
    				if(not_list_chk.equals("021930027534")) continue;
    				if(not_list_chk.equals("017309021847")) continue;
    				if(not_list_chk.equals("017309021967")) continue;
    				if(not_list_chk.equals("014731021657")) continue;
    				if(not_list_chk.equals("014731021651")) continue;
    				 
    				if(not_list_chk.equals("009671024050")) continue;
    				if(not_list_chk.equals("009671024063")) continue;
    				if(not_list_chk.equals("017817022601")) continue;
    				if(not_list_chk.equals("017817022602")) continue;
    				if(not_list_chk.equals("008486020364")) continue;
    				if(not_list_chk.equals("008486019842")) continue;
    				if(not_list_chk.equals("005726028850")) continue;
    				if(not_list_chk.equals("005726028851")) continue;    				
    				if(not_list_chk.equals("016721026428")) continue;
    				if(not_list_chk.equals("016721026429")) continue;
    				if(not_list_chk.equals("007440028177")) continue;
    				if(not_list_chk.equals("007440028167")) continue;
    				if(not_list_chk.equals("011382014521")) continue;
    				if(not_list_chk.equals("011382014480")) continue;
    				if(not_list_chk.equals("016916023573")) continue;
    				if(not_list_chk.equals("016916023575")) continue;
    				if(not_list_chk.equals("012369025832")) continue;
    				if(not_list_chk.equals("012857025602")) continue;
    				if(not_list_chk.equals("012857025534")) continue;
    				if(not_list_chk.equals("007272024281")) continue;
    				if(not_list_chk.equals("007272024184")) continue;    				
    				if(not_list_chk.equals("016974028139")) continue;
    				if(not_list_chk.equals("016974028140")) continue;
    				if(not_list_chk.equals("012323019760")) continue;
    				if(not_list_chk.equals("012323019742")) continue;
    				if(not_list_chk.equals("010642027703")) continue;
    				if(not_list_chk.equals("010642027702")) continue;
    				if(not_list_chk.equals("016738026344")) continue;
    				if(not_list_chk.equals("009495027011")) continue;
    				if(not_list_chk.equals("009495027149")) continue;
    				if(not_list_chk.equals("015159026066")) continue;
    				if(not_list_chk.equals("015159026005")) continue;
    				if(not_list_chk.equals("017294024166")) continue;
    				if(not_list_chk.equals("017294024422")) continue;
    				if(not_list_chk.equals("011553021398")) continue;
    				if(not_list_chk.equals("011553021399")) continue;    				
    				if(not_list_chk.equals("008538021404")) continue;
    				if(not_list_chk.equals("008538021609")) continue;
    				if(not_list_chk.equals("006905017372")) continue;
    				if(not_list_chk.equals("006905017369")) continue;
    				if(not_list_chk.equals("011358027613")) continue;
    				if(not_list_chk.equals("011358027547")) continue;

    				
    					
    	%> 
                <tr align="center"> 
                    <td><%=i+1%></td>
                    <td><%=ht.get("FIRM_NM")%></td>										
                    <td><%=ht.get("USER_NM")%></td>															
                    <td><%=ht.get("RENT_L_CD")%></td>
                    <td><%=ht.get("CAR_MNG_ID")%></td>					
                    <td><%=ht.get("ACCID_ID")%></td>
                    <td><%=ht.get("CAR_NO")%></td>					
                    <td><%=ht.get("ACCID_ST_NM")%></td>					
                    <td><%=ht.get("ACCID_DT")%></td>
                    <td><%=ht.get("REG_DT")%></td>
                    <td><%=ht.get("REG_NM")%></td>
                    <td><%=ht.get("TOT_AMT")%></td>
                    <td><%=ht.get("SERV_ST")%></td>
                    <td><%=ht.get("RES_ST")%></td>
                    <td><%=ht.get("PIC_CNT")%></td>
                    <td><%=ht.get("MY_CNT")%></td>
                </tr>
          <%}%>		  		  
            </table>
        </td>
    </tr>	
    <tr> 
        <td align="right"><a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
