<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cus_pre.*, acar.user_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String dept_id = request.getParameter("dept_id")==null?"":request.getParameter("dept_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	CusPre_Database cp_db = CusPre_Database.getInstance();
	int[] mng = cp_db.getTg_md2(cmd, dept_id);		//getTg_month
	int[] pre = cp_db.getTg_md_pre2(cmd, dept_id);	//getTg_month_pre
	
	float cm_rate = 0.0f;
	float rm_rate = 0.0f;
	float crm_rate = 0.0f;
	if(pre[1]!=0)	cm_rate = pre[2]*100/(float)pre[1];
	if(pre[4]!=0)	rm_rate = pre[5]*100/(float)pre[4];
	if(pre[1]!=0 &&pre[4]!=0)	crm_rate = (pre[2]+pre[5])*100/(float)(pre[0]+pre[3]);
	
	Vector cpams = cp_db.getCusPreAll_md2(cmd, dept_id);	//getCusPreAll_month
	Vector rs = cp_db.getTg_rs2(cmd, dept_id);				//배차,반차현황 getTg_month_rs
	
	int total = 0;
	int rsd1=0,rsr1=0,rsd2=0,rsr2=0,rsd3=0,rsr3=0,rsd67=0,rsr67=0,rsd9=0,rsr9=0,rsd10=0,rsr10=0;
	int vac=0,vec=0,vc=0,sac=0,sec=0,sc=0,cs1=0,cs2=0,cs3=0,mac1=0,mac2=0,irh=0,irc=0;
	float tot_v_rate=0.0f, tot_s_rate=0.0f, tot_vs_rate=0.0f;
	
		//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 3; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈

%>
<html>
<head>
<title>:: FMS ::</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function st(arg){
	var fm = document.form1;
	fm.action = "cus_pre_st_md.jsp?cmd="+arg;
	fm.target = "c_body";
	fm.submit();
}
-->
</script>
</head>

<body>
<form name='form1' method='post' action=''>
<input type='hidden' name='dept_id' value='<%=dept_id%>'> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
        <td valign=top> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                    <td width=40%><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>관리현황</span></td>
                    <td width=5% rowspan="4">&nbsp;</td>
                    <td width=55%><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>당<% if(cmd.equals("m")) out.print("월"); else out.print("일"); %> 업무추진현황</span></td>
                </tr>
                <tr>
                    <td valign=top>
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr>
                                <td class=line> 
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                    	<tr><td class=line2 colspan=3 style='height:1'></td></tr>
                                        <tr> 
                                            <td width=24% class='title' align="center">구분</td>
                                            <td width=38% class='title' align="center">거래처</td>
                                            <td width=38% class='title' align="center">자동차</td>
                                        </tr>
                                        <tr> 
                                            <td class='title' align="center">단독관리</td>
                                            <td align="center"> <a href="#"><%= mng[0] %>건</a></td>
                                            <td align="center"> <a href="#"><%= mng[2] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td class='title' align="center">공동관리</td>
                                            <td align="center"><a href="#"><%= mng[1] %>건</a></td>
                                            <td align="center"><a href="#"><%= mng[3] %>건</a></td>
                                        </tr>
                                        <tr> 
                                            <td class='title' align="center">합계</td>
                                            <td align="center"><a href="#"><%= mng[0]+mng[1] %>건</a></td>
                                            <td align="center"><a href="#"><%= mng[2]+mng[3] %>건</a></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td class=line rowspan="3"> 
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        	<tr><td class=line2 style='height:1' colspan=2></td></tr>
                            <tr align="center"> 
                                <td class=title width=50%>거래처방문</td>
                                <td class=title width=50%>자동차관리</td>
                            </tr>
                            <tr> 
                                <td valign=middle>
                                    <table width=220 border="0" cellspacing="0" cellpadding="0" align="center">
                                        <tr>
                                            <td class=h></td>
                                        </tr>
                                        <tr>
                                            <td class=h></td>
                                        </tr>
                                        <tr> 
                                            <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top"> 
                                                <br>
                                                <font size="1">100%</font> </td>
                                            <td>&nbsp;</td>
                                            <td> 
                                                <table width="40" border="0" cellspacing="0" cellpadding="0" height="120">
                                                    <tr> 
                                                        <td height="20" valign="bottom" align="center"><a href="#"><%= pre[0] %>건</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td valign="bottom" height="100"><img src=../../images/menu_back2.gif width=40 height=<%= pre[0]*150/1000 %>></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>&nbsp;</td>
                                            <td> 
                                                <table width="40" border="0" cellspacing="0" cellpadding="0" height="120">
                                                    <tr> 
                                                        <td height="19" valign="bottom" align="center"><a href="#"><%= pre[1] %>건</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td valign="bottom" height="81"><img src=../../images/menu_back.gif width=40 height=<%= pre[1]*150/1000 %>></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>&nbsp;</td>
                                            <td> 
                                                <table width="40" border="0" cellspacing="0" cellpadding="0" height="120">
                                                    <tr> 
                                                        <td height="68" valign="bottom" align="center"><a href="#"><%= pre[2] %>건</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td height="32" valign="bottom"><img src=../../images/result1.gif width=40 height=<%= pre[2]*150/1000 %>></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td>&nbsp;</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">전체</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">예정</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">실시</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td align="center">&nbsp;</td>
                                            <td colspan="7" align="center"><font color="#999900">실시율 <%= AddUtil.parseFloatCipher(cm_rate,2) %>%</font><br><br></td>
                                        </tr>
                                    </table>
                                </td>
                                <td> 
                                    <table width=220 border="0" cellspacing="0" cellpadding="0" align="center">
                                        <tr> 
                                            <td style="border-top: #000000 0px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 1px solid" height="120" valign="top"> 
                                                <br>
                                                <font size="1">100%</font> </td>
                                            <td>&nbsp;</td>
                                            <td> 
                                                <table width="40" border="0" cellspacing="0" cellpadding="0" height="120">
                                                    <tr> 
                                                      <td height="20" valign="bottom" align="center"><a href="#"><%= pre[3] %>건</a></td>
                                                    </tr>
                                                    <tr> 
                                                      <td valign="bottom" height="100"><img src=../../images/menu_back2.gif width=40 height=<%= pre[3]*150/1000 %>></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>&nbsp;</td>
                                            <td valign=bottom> 
                                                <table width="40" border="0" cellspacing="0" cellpadding="0" height="120">
                                                    <tr> 
                                                        <td height="19" valign="bottom" align="center"><a href="#"><%= pre[4] %>건</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td valign="bottom" height="81"><img src=../../images/menu_back.gif width=40 height=<%= pre[4]*150/1000 %>></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>&nbsp;</td>
                                            <td valign=bottom> 
                                                <table width="40" border="0" cellspacing="0" cellpadding="0" height="120">
                                                    <tr> 
                                                        <td height="68" valign="bottom" align="center"><a href="#"><%= pre[5] %>건</a></td>
                                                    </tr>
                                                    <tr> 
                                                        <td height="32" valign="bottom"><img src=../../images/result1.gif width=40 height=<%= pre[5]*150/1000 %>></td>
                                                    </tr>
                                                </table>
                                            </td>
                                            <td>&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td>&nbsp;</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">전체</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">예정</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">&nbsp;</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid" align="center">실시</td>
                                            <td style="border-top: #000000 1px solid; border-left: #000000 0px solid; border-bottom: #000000 0px solid; border-right: #000000 0px solid">&nbsp;</td>
                                        </tr>
                                        <tr> 
                                            <td align="center">&nbsp;</td>
                                            <td colspan="7" align="center"><font color="#999900">실시율 <%= AddUtil.parseFloatCipher(rm_rate,2) %>%</font><br> <br></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td valign=top>
                        <table width="100%" border="0" cellspacing="1" cellpadding="0">
                            <tr> 
                                <td valign=top class=line> 
                                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                                    	<tr><td class=line2 colspan=4 style='height:1'></td></tr>
                                        <tr> 
                                            <td width=24% class=title>구분</td>
                                            <td width=25% class=title>일반식</td>
                                            <td width=25% class=title>기본식/맞춤식</td>
                                            <td class=title width=26%>합계</td>
                                        </tr>
                                        <tr> 
                                            <td class=title>렌트</td>
                                            <td align="center"><a href="#"><%= mng[4] %>대</a></td>
                                            <td align="center"><a href="#"><%= mng[5] %>대</a></td>
                                            <td align="center"><a href="#"><%= mng[4]+ mng[5] %>대</a></td>
                                        </tr>
                                        <tr> 
                                            <td class=title>리스</td>
                                            <td align="center"><a href="#"><%= mng[6] %>대</a></td>
                                            <td align="center"><a href="#"><%= mng[7] %>대</a></td>
                                            <td align="center"><a href="#"><%= mng[6]+ mng[7] %>대</a></td>
                                        </tr>
                                        <tr> 
                                            <td class=title>합계</td>
                                            <td align="center"><a href="#"><%= mng[4]+ mng[6] %>대</a></td>
                                            <td align="center"><a href="#"><%= mng[5]+ mng[7] %>대</a></td>
                                            <td align="center"><a href="#"><%= mng[4]+ mng[5]+mng[6]+mng[7] %>대</a></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>당<% if(cmd.equals("m")) out.print("월"); else out.print("일"); %> 업무현황</span>
        <a href="javascript:st('<%=cmd%>')" onMouseOver="window.status=''; return true" onFocus="this.blur()"><img src=/acar/images/center/button_graph.gif align=absmiddle border=0></a></td>
    </tr>
    <tR>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">              	
                <tr> 
                    <td class='title' align="center" width=4% rowspan="3">연번</td>
                    <td class='title' align="center" width=8% rowspan="3">성명</td>
                    <td rowspan="3" class='title' align="center" width=7%>관리업무<br>시행율 </td>
                    <td width=6% rowspan="3" align="center" class='title'>담당<br>거래처수</td>
                    <td colspan="3" align="center" class='title'>거래처 방문 관리</td>
                    <td width=6% rowspan="3" align="center" class='title'>관리<br>담당<br>자동차수 </td>
                    <td colspan="6" align="center" class='title'>자동차 관리</td>
                    <td colspan="2" align="center" class='title'>운행차검사</td>
                    <td colspan="2" align="center" class='title'>FMS접수업무</td>
                </tr>
                <tr> 
                    <td width=5% class='title' align="center" rowspan="2">예정</td>
                    <td width=5% class='title' align="center" rowspan="2">실시</td>
                    <td width=6% class='title' align="center" rowspan="2">실시율</td>
                    <td width=5% class='title' align="center" rowspan="2">예정</td>
                    <td class='title' align="center" colspan="4">업무수행자</td>
                    <td width=6% class='title' align="center" rowspan="2">실시율</td>
                    <td width=6% align="center" class='title'>정기검사</td>
                    <td width=6% align="center" class='title'>정밀검사</td>
                    <td width=5% rowspan="2" align="center" class='title'>접수</td>
                    <td width=5% rowspan="2" align="center" class='title'>시행</td>
                </tr>
                <tr> 
                    <td width=5% class='title' align="center">본인</td>
                    <td width=5% class='title' align="center">지원</td>
                    <td width=5% class='title' align="center">고객</td>
                    <td width=5% class='title' align="center">계</td>
                    <td align="center" class='title'>실시</td>
                    <td align="center" class='title'>실시</td>
                </tr>
                  <%for(int i=0; i<cpams.size(); i++){
        				Hashtable ht = (Hashtable)cpams.elementAt(i);
						String userid = (String)ht.get("USER_ID");
						
        				float v_rate = 0.0f, s_rate = 0.0f, vs_rate = 0.0f;
        				if(AddUtil.parseInt((String)ht.get("VEC"))>0) v_rate = (float)AddUtil.parseInt((String)ht.get("VC"))*100/(AddUtil.parseInt((String)ht.get("VEC")));
        				if(AddUtil.parseInt((String)ht.get("SEC"))>0) s_rate = (float)AddUtil.parseInt((String)ht.get("SC"))*100/(AddUtil.parseInt((String)ht.get("SEC")));
        				//vs_rate = (float)(AddUtil.parseInt((String)ht.get("VC"))+AddUtil.parseInt((String)ht.get("SC")))*100/(AddUtil.parseInt((String)ht.get("VAC"))+(AddUtil.parseInt((String)ht.get("SAC"))));
        				vs_rate = (v_rate+s_rate)/2;
        				tot_v_rate += v_rate; tot_s_rate += s_rate; tot_vs_rate += vs_rate;
        				vac += AddUtil.parseInt((String)ht.get("VAC")); vec += AddUtil.parseInt((String)ht.get("VEC")); vc += AddUtil.parseInt((String)ht.get("VC"));
        				sac += AddUtil.parseInt((String)ht.get("SAC")); sec += AddUtil.parseInt((String)ht.get("SEC")); sc += AddUtil.parseInt((String)ht.get("SC"));
        				cs1 += AddUtil.parseInt((String)ht.get("CS1")); cs2 += AddUtil.parseInt((String)ht.get("CS2")); cs3 += AddUtil.parseInt((String)ht.get("CS3"));
        				mac1 += AddUtil.parseInt((String)ht.get("MAC1")); mac2 += AddUtil.parseInt((String)ht.get("MAC2")); irh += AddUtil.parseInt((String)ht.get("IRH")); irc += AddUtil.parseInt((String)ht.get("IRC"));
        		 %>
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><a href="cus_pre_frame.jsp?auth_rw=<%= auth_rw %>&br_id=<%= br_id %>&user_id=<%= ht.get("USER_ID") %>&cmd=pre" target="d_content"><%= c_db.getNameById((String)ht.get("USER_ID"),"USER") %></a></td>
                    <td align="right"><%=AddUtil.parseFloatCipher2(vs_rate,2) %>&nbsp;</td>
                    <td align="right"><%= ht.get("VAC") %>&nbsp;</td>
                    <td align="right"><%= ht.get("VEC") %>&nbsp;</td>
                    <td align="right"><%= ht.get("VC") %>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseFloatCipher2(v_rate,2) %>&nbsp;</td>
                    <td align="right"><%= ht.get("SAC") %>&nbsp;</td>
                    <td align="right"><%= ht.get("SEC") %>&nbsp;</td>
                    <td align="right"><%= ht.get("CS1") %>&nbsp;</td>
                    <td align="right"><%= ht.get("CS2") %>&nbsp;</td>
                    <td align="right"><%= ht.get("CS3") %>&nbsp;</td>
                    <td align="right"><%= ht.get("SC") %>&nbsp;</td>
                    <td align="right"><%= AddUtil.parseFloatCipher2(s_rate,2) %>&nbsp;</td>
                    <td align="right"><%= ht.get("MAC1") %>&nbsp;&nbsp;</td>
                    <td align="right"><%= ht.get("MAC2") %>&nbsp;&nbsp;</td>
                    <td align="right"><%= ht.get("IRH") %>&nbsp;&nbsp;</td>
                    <td align="right"><%= ht.get("IRC") %>&nbsp;&nbsp;</td>
                </tr>
                  <% } %>
                <tr> 
                    <td class='title' align="center">&nbsp;</td>
                    <td class='title' align="center">합계</td>
                    <td class='title' style="text-align:right"><%= AddUtil.parseFloatCipher2(((vc+sc)*100/(float)(vec+sec)),2) %>&nbsp;</td>
                    <td class='title' style="text-align:right"><%= vac %>&nbsp;</td>
                    <td class='title' style="text-align:right"><%= vec %>&nbsp;</td>
                    <td class='title' style="text-align:right"><%= vc %>&nbsp;</td>
                    <td class='title' style="text-align:right"><%= AddUtil.parseFloatCipher2((vc*100/(float)vec),2) %>&nbsp;</td>
                    <td class='title' style="text-align:right"><%= sac %>&nbsp;</td>
                    <td class='title' style="text-align:right"><%= sec %>&nbsp;</td>
                    <td class='title' style="text-align:right"><%= cs1 %>&nbsp;</td>
                    <td class='title' style="text-align:right"><%= cs2 %>&nbsp;</td>
                    <td class='title' style="text-align:right"><%= cs3 %>&nbsp;</td>
                    <td class='title' style="text-align:right"><%= sc %>&nbsp;</td>
                    <td class='title' style="text-align:right"><%= AddUtil.parseFloatCipher2((sc*100/(float)sec),2) %>&nbsp;</td>
                    <td class='title' style="text-align:right"><%= mac1 %>&nbsp;&nbsp;</td>
                    <td class='title' style="text-align:right"><%= mac2 %>&nbsp;&nbsp;</td>
                    <td class='title' style="text-align:right"><%= irh %>&nbsp;&nbsp;</td>
                    <td class='title' style="text-align:right"><%= irc %>&nbsp;&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>당<% if(cmd.equals("m")) out.print("월"); else out.print("일"); %> 계약변경현황</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class='title' align="center" width=12%>신규계약개시</td>
                    <td align="center" width=38%><%= mng[8] %> 건</td>
                    <td class='title' align="center" width=12%>계약만료도래</td>
                    <td width=38% align="center"><%= mng[9] %> 건</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>당<% if(cmd.equals("m")) out.print("월"); else out.print("일"); %> 배차/반차업무현황</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr> 
                    <td class='title' align="center" width=4% rowspan="2">연번</td>
                    <td class='title' align="center" width=8% rowspan="2">성명</td>
                    <td class='title' align="center" width=4% rowspan="2">합계</td>
                    <td class='title' align="center" colspan="2">단기대여</td>
                    <td class='title' align="center" colspan="2">보험대차</td>
                    <td class='title' align="center" colspan="2">지연대차</td>
                    <td class='title' align="center" colspan="2">정비대차</td>
                    <td class='title' align="center" colspan="2">사고대차</td>
                    <td class='title' align="center" colspan="2">차량정비</td>
                </tr>
                <tr> 
                    <td width=7% class='title' align="center">배차</td>
                    <td width=7% class='title' align="center">반차</td>
                    <td width=7% class='title' align="center">배차</td>
                    <td width=7% class='title' align="center">반차</td>
                    <td width=7% class='title' align="center">배차</td>
                    <td width=7% class='title' align="center">반차</td>
                    <td width=7% class='title' align="center">배차</td>
                    <td width=7% class='title' align="center">반차</td>
                    <td width=7% class='title' align="center">배차</td>
                    <td width=7% class='title' align="center">반차</td>
                    <td width=7% class='title' align="center">배차</td>
                    <td width=7% class='title' align="center">반차</td>
                </tr>
                  <%for(int i=0; i<rs.size(); i++){
        				Hashtable ht = (Hashtable)rs.elementAt(i);
						String userid = (String)ht.get("ID");
						
        				total += AddUtil.parseInt((String)ht.get("TOT"));
        				rsd1 += AddUtil.parseInt((String)ht.get("RSD1"));	rsr1 += AddUtil.parseInt((String)ht.get("RSR1"));
        				rsd2 += AddUtil.parseInt((String)ht.get("RSD2"));	rsr2 += AddUtil.parseInt((String)ht.get("RSR2"));
        				rsd3 += AddUtil.parseInt((String)ht.get("RSD3"));	rsr3 += AddUtil.parseInt((String)ht.get("RSR3"));
        				rsd67 += AddUtil.parseInt((String)ht.get("RSD67"));	rsr67 += AddUtil.parseInt((String)ht.get("RSR67"));
        				rsd9 += AddUtil.parseInt((String)ht.get("RSD9"));	rsr9 += AddUtil.parseInt((String)ht.get("RSR9"));
        				rsd10 += AddUtil.parseInt((String)ht.get("RSD10"));	rsr10 += AddUtil.parseInt((String)ht.get("RSR10"));
        				 %>
                <tr> 
                    <td align="center"><%= i+1 %></td>
                    <td align="center"><%= c_db.getNameById((String)ht.get("ID"),"USER") %></td>
                    <td align="right"><%= ht.get("TOT") %>&nbsp;&nbsp;</td>
                    <td align="right"><%= ht.get("RSD1") %>&nbsp;</td>
                    <td align="right"><%= ht.get("RSR1") %>&nbsp;</td>
                    <td align="right"><%= ht.get("RSD9") %>&nbsp;</td>
                    <td align="right"><%= ht.get("RSR9") %>&nbsp;</td>
                    <td align="right"><%= ht.get("RSD10") %>&nbsp;</td>
                    <td align="right"><%= ht.get("RSR10") %>&nbsp;</td>
                    <td align="right"><%= ht.get("RSD2") %>&nbsp;</td>
                    <td align="right"><%= ht.get("RSR2") %>&nbsp;</td>
                    <td align="right"><%= ht.get("RSD3") %>&nbsp;</td>
                    <td align="right"><%= ht.get("RSR3") %>&nbsp;</td>
                    <td align="right"><%= ht.get("RSD67") %>&nbsp;</td>
                    <td align="right"><%= ht.get("RSR67") %>&nbsp;</td>
                </tr>
        		  <% } %>		  
                <tr> 
                    <td class='title' align="center">&nbsp;</td>
                    <td class='title' align="center">합계</td>
                    <td class='title'><%= total %>&nbsp;&nbsp;</td>
                    <td class='title' align="right"><%= rsd1 %>&nbsp;</td>
                    <td class='title' align="right"><%= rsr1 %>&nbsp;</td>
                    <td class='title' align="right"><%= rsd9 %>&nbsp;</td>
                    <td class='title' align="right"><%= rsr9 %>&nbsp;</td>
                    <td class='title' align="right"><%= rsd10 %>&nbsp;</td>
                    <td class='title' align="right"><%= rsr10 %>&nbsp;</td>
                    <td class='title' align="right"><%= rsd2 %>&nbsp;</td>
                    <td class='title' align="right"><%= rsr2 %>&nbsp;</td>
                    <td class='title' align="right"><%= rsd3 %>&nbsp;</td>
                    <td class='title' align="right"><%= rsr3 %>&nbsp;</td>
                    <td class='title' align="right"><%= rsd67 %>&nbsp;</td>
                    <td class='title' align="right"><%= rsr67 %>&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
</body>
</html>

